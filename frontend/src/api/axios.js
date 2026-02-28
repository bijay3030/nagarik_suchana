import axios from "axios"

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || "http://localhost:3000",
  headers: { "Content-Type": "application/json" },
  withCredentials: false,
  timeout: 10000
})

api.interceptors.request.use(
  (config) => {
    const token = sessionStorage.getItem("auth_token")
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => Promise.reject(error)
)

api.interceptors.response.use(
  (response) => response,
  (error) => {
    const status = error.response?.status

    if (status === 401) {
      sessionStorage.removeItem("auth_token")
      sessionStorage.removeItem("auth_user")
      window.location.href = "/login?reason=session_expired"
    }

    if (status === 403) {
      window.location.href = "/unauthorized"
    }

    return Promise.reject(error)
  }
)

export default api
