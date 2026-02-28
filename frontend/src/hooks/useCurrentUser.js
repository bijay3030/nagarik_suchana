import { useEffect } from "react"
import { useQuery } from "@tanstack/react-query"
import { authApi } from "../api/authApi"
import useAuthStore from "../stores/authStore"

export const useCurrentUser = () => {
  const { token, isAuthenticated } = useAuthStore()

  const query = useQuery({
    queryKey: ["currentUser"],
    queryFn: authApi.me,
    enabled: isAuthenticated && !!token,
    staleTime: 5 * 60 * 1000,
    gcTime: 10 * 60 * 1000,
    retry: false,
    refetchOnWindowFocus: true
  })

  useEffect(() => {
    if (query.isError) {
      useAuthStore.getState().clearAuth()
    }
  }, [query.isError])

  return query
}
