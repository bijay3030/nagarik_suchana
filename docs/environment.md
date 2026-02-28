# Environment Variables

| Variable              | Required | Description                        |
|-----------------------|----------|------------------------------------|
| DATABASE_URL          | Yes      | Full PostgreSQL connection string  |
| DEVISE_JWT_SECRET_KEY | Yes      | Secret for signing JWT tokens      |
| REDIS_URL             | Yes      | Redis connection for cache/jobs    |
| FRONTEND_URL          | Yes      | React app URL for CORS             |
| RAILS_ENV             | Yes      | development / test / production    |
| PORT                  | No       | Server port, defaults to 3000      |
