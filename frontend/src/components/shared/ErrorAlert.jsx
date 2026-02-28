import { AlertCircle } from "lucide-react"
import { Alert, AlertDescription } from "../ui/alert"

export const ErrorAlert = ({ message }) => {
  if (!message) return null

  return (
    <Alert variant="destructive" className="mb-4">
      <AlertCircle className="h-4 w-4" />
      <AlertDescription>{message}</AlertDescription>
    </Alert>
  )
}
