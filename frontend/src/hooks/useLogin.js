import { useMutation, useQueryClient } from "@tanstack/react-query"
import { useNavigate } from "react-router-dom"
import toast from "react-hot-toast"
import { authApi } from "../api/authApi"
import useAuthStore from "../stores/authStore"

const ROLE_REDIRECT = {
  admin: "/admin/dashboard",
  business: "/business/dashboard",
  user: "/dashboard"
}

export const useLogin = () => {
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const { setAuth } = useAuthStore()

  return useMutation({
    mutationFn: (credentials) => authApi.login(credentials),

    onSuccess: ({ user, token }) => {
      setAuth(user, token)
      queryClient.setQueryData(["currentUser"], user)
      toast.success(`Welcome back, ${user.first_name}! 👋`)
      navigate(ROLE_REDIRECT[user.role] || "/dashboard", { replace: true })
    },

    onError: (error) => {
      const message =
        error.response?.data?.error ||
        error.response?.data?.message ||
        "Login failed. Please check your credentials."

      toast.error(message)
    }
  })
}
