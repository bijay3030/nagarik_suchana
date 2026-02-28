export const Logo = ({ size = "md" }) => {
  const sizes = {
    sm: "text-xl",
    md: "text-2xl",
    lg: "text-4xl"
  }

  return (
    <div className="flex items-center gap-2">
      <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary">
        <span className="text-sm font-bold text-primary-foreground">M</span>
      </div>
      <span className={`font-bold text-foreground ${sizes[size]}`}>Nagarik Suchana</span>
    </div>
  )
}
