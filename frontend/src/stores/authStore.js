import { create } from "zustand"

const TOKEN_KEY = "auth_token"
const USER_KEY = "auth_user"

const useAuthStore = create((set) => ({
  user: getStoredUser(),
  token: getStoredToken(),
  isAuthenticated: !!getStoredToken(),

  setAuth: (user, token) => {
    sessionStorage.setItem(TOKEN_KEY, token)
    sessionStorage.setItem(USER_KEY, JSON.stringify(user))

    set({
      user,
      token,
      isAuthenticated: true
    })
  },

  clearAuth: () => {
    sessionStorage.removeItem(TOKEN_KEY)
    sessionStorage.removeItem(USER_KEY)

    set({
      user: null,
      token: null,
      isAuthenticated: false
    })
  },

  updateUser: (user) => {
    sessionStorage.setItem(USER_KEY, JSON.stringify(user))
    set({ user })
  }
}))

function getStoredToken() {
  return sessionStorage.getItem(TOKEN_KEY)
}

function getStoredUser() {
  try {
    const raw = sessionStorage.getItem(USER_KEY)
    return raw ? JSON.parse(raw) : null
  } catch {
    return null
  }
}

export default useAuthStore
