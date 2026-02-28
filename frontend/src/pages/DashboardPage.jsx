import { LogOut, User, Settings } from "lucide-react"
import { Button } from "../components/ui/button"
import { Avatar, AvatarFallback } from "../components/ui/avatar"
import { Badge } from "../components/ui/badge"
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card"
import { LoadingSpinner } from "../components/shared/LoadingSpinner"
import { useLogout } from "../hooks/useLogout"
import { useCurrentUser } from "../hooks/useCurrentUser"

const ROLE_COLORS = {
  admin: "destructive",
  business: "default",
  user: "secondary"
}

const DashboardPage = () => {
  const { data: user, isLoading } = useCurrentUser()
  const logout = useLogout()

  if (isLoading) {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <LoadingSpinner size="lg" />
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-slate-50">
      <header className="sticky top-0 z-10 border-b bg-white shadow-sm">
        <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-6">
          <div className="flex items-center gap-3">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary">
              <span className="text-sm font-bold text-primary-foreground">M</span>
            </div>
            <span className="font-semibold text-foreground">MyApp</span>
          </div>
          <div className="flex items-center gap-4">
            <div className="flex items-center gap-3">
              <Avatar className="h-8 w-8">
                <AvatarFallback className="bg-primary text-xs font-medium text-primary-foreground">
                  {user?.initials || "U"}
                </AvatarFallback>
              </Avatar>
              <div className="hidden sm:block">
                <p className="text-sm font-medium leading-none">{user?.full_name}</p>
                <p className="text-xs text-muted-foreground">{user?.email}</p>
              </div>
              <Badge variant={ROLE_COLORS[user?.role] || "secondary"} className="capitalize">
                {user?.role}
              </Badge>
            </div>
            <Button
              variant="ghost"
              size="sm"
              onClick={() => logout.mutate()}
              disabled={logout.isPending}
              className="gap-2 text-muted-foreground"
            >
              {logout.isPending ? <LoadingSpinner size="sm" /> : <LogOut className="h-4 w-4" />}
              <span className="hidden sm:inline">Sign out</span>
            </Button>
          </div>
        </div>
      </header>

      <main className="mx-auto max-w-7xl px-6 py-10">
        <div className="mb-8">
          <h1 className="text-3xl font-bold tracking-tight text-foreground">Welcome back, {user?.first_name}! 👋</h1>
          <p className="mt-1 text-muted-foreground">Here&apos;s what&apos;s happening with your account today.</p>
        </div>

        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="flex items-center gap-2 text-sm font-medium text-muted-foreground">
                <User className="h-4 w-4" />
                Account
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold">{user?.full_name}</p>
              <p className="mt-1 text-sm text-muted-foreground">{user?.email}</p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="flex items-center gap-2 text-sm font-medium text-muted-foreground">
                <Settings className="h-4 w-4" />
                Role
              </CardTitle>
            </CardHeader>
            <CardContent>
              <Badge variant={ROLE_COLORS[user?.role]} className="px-3 py-1 text-base capitalize">
                {user?.role}
              </Badge>
              <p className="mt-2 text-sm text-muted-foreground">
                Access level: {user?.role === "admin" ? "Full" : user?.role === "business" ? "Business" : "Standard"}
              </p>
            </CardContent>
          </Card>

          <Card>
            <CardHeader className="pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">Member Since</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold">
                {new Date(user?.created_at).toLocaleDateString("en-US", {
                  month: "long",
                  year: "numeric"
                })}
              </p>
            </CardContent>
          </Card>
        </div>
      </main>
    </div>
  )
}

export default DashboardPage
