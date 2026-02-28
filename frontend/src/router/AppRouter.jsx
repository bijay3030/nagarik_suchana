import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom"
import { AuthGuard } from "../components/auth/AuthGuard"
import LoginPage from "../pages/LoginPage"
import DashboardPage from "../pages/DashboardPage"
import AdminPage from "../pages/AdminPage"
import BusinessPage from "../pages/BusinessPage"
import UnauthorizedPage from "../pages/UnauthorizedPage"

export const AppRouter = () => (
  <BrowserRouter>
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route path="/unauthorized" element={<UnauthorizedPage />} />

      <Route
        path="/dashboard"
        element={
          <AuthGuard>
            <DashboardPage />
          </AuthGuard>
        }
      />

      <Route
        path="/business/dashboard"
        element={
          <AuthGuard requiredRole="business">
            <BusinessPage />
          </AuthGuard>
        }
      />

      <Route
        path="/admin/dashboard"
        element={
          <AuthGuard requiredRole="admin">
            <AdminPage />
          </AuthGuard>
        }
      />

      <Route path="/" element={<Navigate to="/login" replace />} />
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  </BrowserRouter>
)
