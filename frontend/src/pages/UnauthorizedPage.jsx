import { useNavigate } from "react-router-dom"
import { ShieldX } from "lucide-react"
import { Button } from "../components/ui/button"

const UnauthorizedPage = () => {
  const navigate = useNavigate()

  return (
    <div className="flex min-h-screen flex-col items-center justify-center gap-6 bg-slate-50 p-6 text-center">
      <div className="flex h-20 w-20 items-center justify-center rounded-full bg-destructive/10">
        <ShieldX className="h-10 w-10 text-destructive" />
      </div>
      <div className="space-y-2">
        <h1 className="text-3xl font-bold">Access Denied</h1>
        <p className="max-w-sm text-muted-foreground">
          You don&apos;t have permission to view this page. Contact your administrator if you believe this is a mistake.
        </p>
      </div>
      <div className="flex gap-3">
        <Button variant="outline" onClick={() => navigate(-1)}>
          Go Back
        </Button>
        <Button onClick={() => navigate("/dashboard")}>Go to Dashboard</Button>
      </div>
    </div>
  )
}

export default UnauthorizedPage
