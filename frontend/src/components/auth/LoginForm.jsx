import { useEffect, useState } from "react"
import { Link } from "react-router-dom"
import { useForm } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import { Eye, EyeOff, LogIn, Mail, Lock } from "lucide-react"
import { Button } from "../ui/button"
import { Input } from "../ui/input"
import { Label } from "../ui/label"
import { ErrorAlert } from "../shared/ErrorAlert"
import { LoadingSpinner } from "../shared/LoadingSpinner"
import { useLogin } from "../../hooks/useLogin"
import { loginSchema, loginDefaults } from "../../lib/validation"

export const LoginForm = () => {
  const [showPassword, setShowPassword] = useState(false)
  const login = useLogin()

  const {
    register,
    handleSubmit,
    setValue,
    trigger,
    formState: { errors, isSubmitting }
  } = useForm({
    resolver: zodResolver(loginSchema),
    defaultValues: loginDefaults
  })

  useEffect(() => {
    const handler = (event) => {
      const email = event.detail?.email || ""
      const password = event.detail?.password || ""

      setValue("email", email, { shouldDirty: true, shouldTouch: true, shouldValidate: true })
      setValue("password", password, { shouldDirty: true, shouldTouch: true, shouldValidate: true })
      trigger(["email", "password"])
    }

    window.addEventListener("prefill-login", handler)
    return () => window.removeEventListener("prefill-login", handler)
  }, [setValue, trigger])

  const onSubmit = (data) => {
    login.mutate({
      email: data.email.toLowerCase().trim(),
      password: data.password
    })
  }

  const isLoading = login.isPending || isSubmitting

  const apiError =
    login.error?.response?.data?.error ||
    login.error?.response?.data?.message ||
    (login.isError ? "Invalid email or password. Please try again." : null)

  return (
    <form onSubmit={handleSubmit(onSubmit)} noValidate className="space-y-5">
      <ErrorAlert message={apiError} />

      <div className="space-y-2">
        <Label htmlFor="email">Email address</Label>
        <div className="relative">
          <Mail className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            id="email"
            type="email"
            placeholder="you@example.com"
            autoComplete="email"
            autoFocus
            disabled={isLoading}
            className={`pl-10 ${errors.email ? "border-destructive focus-visible:ring-destructive" : ""}`}
            {...register("email")}
          />
        </div>
        {errors.email && <p className="text-sm text-destructive">{errors.email.message}</p>}
      </div>

      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <Label htmlFor="password">Password</Label>
          <Link to="/forgot-password" className="text-sm font-medium text-primary hover:underline" tabIndex={-1}>
            Forgot password?
          </Link>
        </div>
        <div className="relative">
          <Lock className="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            id="password"
            type={showPassword ? "text" : "password"}
            placeholder="Enter your password"
            autoComplete="current-password"
            disabled={isLoading}
            className={`pl-10 pr-10 ${errors.password ? "border-destructive focus-visible:ring-destructive" : ""}`}
            {...register("password")}
          />
          <button
            type="button"
            onClick={() => setShowPassword((prev) => !prev)}
            className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
            tabIndex={-1}
            aria-label={showPassword ? "Hide password" : "Show password"}
          >
            {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
          </button>
        </div>
        {errors.password && <p className="text-sm text-destructive">{errors.password.message}</p>}
      </div>

      <Button type="submit" className="w-full gap-2" disabled={isLoading} size="lg">
        {isLoading ? (
          <>
            <LoadingSpinner size="sm" />
            Signing in...
          </>
        ) : (
          <>
            <LogIn className="h-4 w-4" />
            Sign in
          </>
        )}
      </Button>
    </form>
  )
}
