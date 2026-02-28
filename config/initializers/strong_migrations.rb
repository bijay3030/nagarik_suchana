return unless defined?(StrongMigrations)

StrongMigrations.start_after = 20240101000000

StrongMigrations.lock_timeout = 10.seconds
StrongMigrations.statement_timeout = 1.hour
StrongMigrations.batch_size = 10_000
