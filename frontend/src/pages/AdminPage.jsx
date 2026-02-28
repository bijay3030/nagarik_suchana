import { LogOut } from "lucide-react"
import { LoadingSpinner } from "../components/shared/LoadingSpinner"
import { Avatar, AvatarFallback } from "../components/ui/avatar"
import { Badge } from "../components/ui/badge"
import { Button } from "../components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "../components/ui/table"
import { useCurrentUser } from "../hooks/useCurrentUser"
import { useLogout } from "../hooks/useLogout"

const notices = [
  {
    id: "GN-2026-001",
    title: "New Municipal Sanitation Schedule",
    department: "Public Works",
    status: "Published",
    publishedAt: "2026-02-24"
  },
  {
    id: "GN-2026-002",
    title: "Water Supply Maintenance Advisory",
    department: "Water Department",
    status: "Draft",
    publishedAt: "2026-02-27"
  },
  {
    id: "GN-2026-003",
    title: "Citizen Hearing on Road Expansion Plan",
    department: "Transport Authority",
    status: "Published",
    publishedAt: "2026-02-22"
  },
  {
    id: "GN-2026-004",
    title: "Ward-Level Waste Segregation Campaign",
    department: "Environment Office",
    status: "Archived",
    publishedAt: "2026-02-10"
  }
]

const statusVariant = {
  Published: "default",
  Draft: "secondary",
  Archived: "outline"
}

const ROLE_COLORS = {
  admin: "destructive",
  business: "default",
  user: "secondary"
}

const AdminPage = () => {
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
              <span className="text-sm font-bold text-primary-foreground">N</span>
            </div>
            <span className="font-semibold text-foreground">Nagarik Suchana</span>
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

      <div className="mx-auto max-w-7xl space-y-6 px-6 py-10">
        <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <h1 className="text-3xl font-bold tracking-tight text-slate-900">Government Notices</h1>
            <p className="text-sm text-slate-600">Manage all public notices published by departments.</p>
          </div>
          <Button>Create Notice</Button>
        </div>

        <Card>
          <CardHeader>
            <CardTitle>Notice Registry</CardTitle>
            <CardDescription>Recent notices and their publication status.</CardDescription>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Notice ID</TableHead>
                  <TableHead>Title</TableHead>
                  <TableHead>Department</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="text-right">Published On</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {notices.map((notice) => (
                  <TableRow key={notice.id}>
                    <TableCell className="font-medium">{notice.id}</TableCell>
                    <TableCell>{notice.title}</TableCell>
                    <TableCell>{notice.department}</TableCell>
                    <TableCell>
                      <Badge variant={statusVariant[notice.status]}>{notice.status}</Badge>
                    </TableCell>
                    <TableCell className="text-right">{notice.publishedAt}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}

export default AdminPage
