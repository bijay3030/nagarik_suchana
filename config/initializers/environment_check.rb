required_env_vars = %w[
  DATABASE_URL
  DEVISE_JWT_SECRET_KEY
  REDIS_URL
  FRONTEND_URL
]

missing = required_env_vars.select { |var| ENV[var].blank? }

if missing.any?
  raise "FATAL: Missing required environment variables: #{missing.join(', ')}\n" \
        "Copy .env.example to .env and fill in all values."
end
