import { useEffect } from "react"
import { useNavigate, useSearchParams, Link } from "react-router-dom"
import { ShieldCheck, Users, BarChart3, AlertCircle } from "lucide-react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle, CardFooter } from "../components/ui/card"
import { Alert, AlertDescription } from "../components/ui/alert"
import { Separator } from "../components/ui/separator"
import { Badge } from "../components/ui/badge"
import { LoginForm } from "../components/auth/LoginForm"
import { Logo } from "../components/shared/Logo"
import useAuthStore from "../stores/authStore"

const DEV_ACCOUNTS = [
  { label: "Admin", email: "admin@myapp.com", password: "Admin@123!", role: "admin", icon: ShieldCheck, color: "destructive" },
  { label: "Business", email: "techcorp@business.com", password: "Business@123!", role: "business", icon: BarChart3, color: "default" },
  { label: "User", email: "alice.johnson@gmail.com", password: "User@123!", role: "user", icon: Users, color: "secondary" }
]

const LoginPage = () => {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const { isAuthenticated, user } = useAuthStore()

  const sessionExpired = searchParams.get("reason") === "session_expired"
  const isDev = import.meta.env.DEV

  useEffect(() => {
    if (isAuthenticated && user) {
      const redirects = { admin: "/admin/dashboard", business: "/business/dashboard", user: "/dashboard" }
      navigate(redirects[user.role] || "/dashboard", { replace: true })
    }
  }, [isAuthenticated, user, navigate])

  return (
    <div className="flex min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-slate-100">
      <div className="hidden lg:flex lg:w-1/2 flex-col justify-between bg-slate-900 p-12">
        <Logo size="md" />
        <div className="space-y-6">
          <h1 className="text-4xl font-bold leading-tight text-white">
            Welcome back to
            <br />
            <span className="text-blue-400">Nagarik Suchana</span>
          </h1>
          <p className="text-lg leading-relaxed text-slate-400">
            Manage your account, access your dashboard, and collaborate with your team - all in one place.
          </p>
          <div className="flex flex-wrap gap-3 pt-4">
            {[
              { icon: ShieldCheck, text: "Secure by default" },
              { icon: Users, text: "Role-based access" },
              { icon: BarChart3, text: "Real-time insights" }
            ].map(({ icon: Icon, text }) => (
              <div key={text} className="flex items-center gap-2 rounded-full bg-slate-800 px-4 py-2 text-sm text-slate-300">
                <Icon className="h-4 w-4 text-blue-400" />
                {text}
              </div>
            ))}
          </div>
        </div>
        <p className="text-sm text-slate-600">© {new Date().getFullYear()} Nagarik Suchana. All rights reserved.</p>
      </div>

      <div className="flex w-full items-center justify-center p-6 lg:w-1/2 lg:p-12">
        <div className="w-full max-w-md space-y-6">
          <div className="flex justify-center lg:hidden">
            <Logo size="lg" />
          </div>

          {sessionExpired && (
            <Alert variant="destructive">
              <AlertCircle className="h-4 w-4" />
              <AlertDescription>Your session has expired. Please sign in again.</AlertDescription>
            </Alert>
          )}

          <Card className="border-0 bg-white/80 shadow-xl backdrop-blur-sm">
            <CardHeader className="space-y-1 pb-6">
              <CardTitle className="text-2xl font-bold tracking-tight">Sign in</CardTitle>
              <CardDescription className="text-base">Enter your credentials to access your account</CardDescription>
            </CardHeader>
            <CardContent>
              <LoginForm />
            </CardContent>
            <CardFooter className="flex flex-col gap-4 pt-0">
              <Separator />
              <p className="text-center text-sm text-muted-foreground">
                Don&apos;t have an account?{" "}
                <Link to="/register" className="font-medium text-primary hover:underline">
                  Create one free
                </Link>
              </p>
            </CardFooter>
          </Card>

          {isDev && (
            <Card className="border-dashed border-amber-300 bg-amber-50">
              <CardHeader className="pb-3 pt-4">
                <CardTitle className="flex items-center gap-2 text-sm font-medium text-amber-800">
                  🛠️ Dev Quick Login
                  <Badge variant="outline" className="border-amber-400 text-xs text-amber-700">
                    DEV ONLY
                  </Badge>
                </CardTitle>
              </CardHeader>
              <CardContent className="pb-4">
                <div className="grid grid-cols-3 gap-2">
                  {DEV_ACCOUNTS.map(({ label, email, password, icon: Icon }) => (
                    <button
                      key={label}
                      type="button"
                      onClick={() => {
                        window.dispatchEvent(
                          new CustomEvent("prefill-login", {
                            detail: { email, password }
                          })
                        )
                      }}
                      className="flex flex-col items-center gap-1 rounded-md border border-amber-200 bg-white p-2 text-xs font-medium text-amber-900 transition-colors hover:bg-amber-100"
                    >
                      <Icon className="h-4 w-4" />
                      {label}
                    </button>
                  ))}
                </div>
                <p className="mt-2 text-center text-xs text-amber-700">Click a role above to pre-fill credentials</p>
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </div>
  )
}

export default LoginPage
