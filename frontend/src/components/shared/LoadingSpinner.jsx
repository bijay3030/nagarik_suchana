import { Loader2 } from "lucide-react"
import { cn } from "../../lib/utils"

export const LoadingSpinner = ({ size = "md", className }) => {
  const sizes = { sm: "h-4 w-4", md: "h-6 w-6", lg: "h-8 w-8" }

  return <Loader2 className={cn("animate-spin text-muted-foreground", sizes[size], className)} />
}
