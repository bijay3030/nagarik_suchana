import { Navigate, useLocation } from "react-router-dom"
import { LoadingSpinner } from "../shared/LoadingSpinner"
import { useCurrentUser } from "../../hooks/useCurrentUser"
import useAuthStore from "../../stores/authStore"

export const AuthGuard = ({ children, requiredRole = null }) => {
  const location = useLocation()
  const { isAuthenticated } = useAuthStore()
  const { data: user, isLoading } = useCurrentUser()

  if (isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <LoadingSpinner size="lg" />
      </div>
    )
  }

  if (!isAuthenticated) {
    return <Navigate to="/login" state={{ from: location }} replace />
  }

  if (requiredRole) {
    const roleHierarchy = { user: 0, business: 1, admin: 2 }
    const userLevel = roleHierarchy[user?.role] ?? -1
    const requiredLevel = roleHierarchy[requiredRole] ?? 999

    if (userLevel < requiredLevel) {
      return <Navigate to="/unauthorized" replace />
    }
  }

  return children
}
