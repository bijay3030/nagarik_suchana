import { useMutation, useQueryClient } from "@tanstack/react-query"
import { useNavigate } from "react-router-dom"
import toast from "react-hot-toast"
import { authApi } from "../api/authApi"
import useAuthStore from "../stores/authStore"

export const useLogout = () => {
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const { clearAuth } = useAuthStore()

  return useMutation({
    mutationFn: () => authApi.logout(),

    onSuccess: () => {
      queryClient.clear()
      clearAuth()
      toast.success("You have been logged out.")
      navigate("/login", { replace: true })
    },

    onError: () => {
      queryClient.clear()
      clearAuth()
      navigate("/login", { replace: true })
    }
  })
}
