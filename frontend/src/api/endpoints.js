const ENDPOINTS = {
  auth: {
    login: "/api/v1/auth/login",
    logout: "/api/v1/auth/logout",
    register: "/api/v1/auth/register",
    me: "/api/v1/auth/me"
  },
  users: {
    profile: "/api/v1/users/profile"
  },
  admin: {
    dashboard: "/api/v1/admin/dashboard"
  },
  business: {
    dashboard: "/api/v1/business/dashboard"
  }
}

export default ENDPOINTS
