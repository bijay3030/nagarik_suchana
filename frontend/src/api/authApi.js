import api from "./axios"
import ENDPOINTS from "./endpoints"

export const authApi = {
  login: async (credentials) => {
    const response = await api.post(ENDPOINTS.auth.login, {
      user: credentials
    })

    const token = response.headers["authorization"] || response.headers["Authorization"]

    if (!token) {
      throw new Error("No authorization token received from server.")
    }

    const cleanToken = token.startsWith("Bearer ") ? token.slice(7) : token

    return {
      user: response.data.data.user,
      token: cleanToken
    }
  },

  logout: async () => {
    const response = await api.delete(ENDPOINTS.auth.logout)
    return response.data
  },

  me: async () => {
    const response = await api.get(ENDPOINTS.auth.me)
    return response.data.data.user
  }
}
