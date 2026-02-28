# ================================================================
# db/seeds.rb - Complete Role-Based User Seed File
# ================================================================
# Run with:  rails db:seed
# Reset and reseed: rails db:seed:replant  (Rails 6+)
# ================================================================

puts "\n#{'=' * 60}"
puts "  SEEDING DATABASE"
puts "#{'=' * 60}\n"

def seed_user(attrs)
  user = User.find_or_create_by!(email: attrs[:email]) do |new_user|
    new_user.assign_attributes(attrs)
  end

  puts "  [CREATED] #{user.email} | #{user.role} | #{user.full_name}"
  user
rescue ActiveRecord::RecordInvalid => e
  existing = User.find_by(email: attrs[:email])
  if existing
    puts "  [SKIP]    #{existing.email} already exists (#{existing.role})"
    existing
  else
    puts "  [ERROR]   Failed to create #{attrs[:email]}: #{e.message}"
    nil
  end
end

puts "\n--- ADMIN USERS ---"

seed_user(
  first_name: "Super",
  last_name: "Admin",
  email: "admin@myapp.com",
  password: "Admin@123!",
  password_confirmation: "Admin@123!",
  role: :admin
)

seed_user(
  first_name: "Sarah",
  last_name: "Operations",
  email: "sarah.ops@myapp.com",
  password: "Admin@123!",
  password_confirmation: "Admin@123!",
  role: :admin
)

seed_user(
  first_name: "James",
  last_name: "Platform",
  email: "james.platform@myapp.com",
  password: "Admin@123!",
  password_confirmation: "Admin@123!",
  role: :admin
)

puts "\n--- BUSINESS USERS ---"

seed_user(
  first_name: "TechCorp",
  last_name: "Solutions",
  email: "techcorp@business.com",
  password: "Business@123!",
  password_confirmation: "Business@123!",
  role: :business
)

seed_user(
  first_name: "Emma",
  last_name: "Ventures",
  email: "emma@greenventures.com",
  password: "Business@123!",
  password_confirmation: "Business@123!",
  role: :business
)

seed_user(
  first_name: "Raj",
  last_name: "Enterprises",
  email: "raj@rajenterprises.com",
  password: "Business@123!",
  password_confirmation: "Business@123!",
  role: :business
)

seed_user(
  first_name: "Priya",
  last_name: "Digital",
  email: "priya@priyaDigital.com",
  password: "Business@123!",
  password_confirmation: "Business@123!",
  role: :business
)

seed_user(
  first_name: "Lucas",
  last_name: "Media",
  email: "lucas@lucasmedia.io",
  password: "Business@123!",
  password_confirmation: "Business@123!",
  role: :business
)

puts "\n--- REGULAR USERS ---"

regular_users = [
  { first_name: "Alice", last_name: "Johnson", email: "alice.johnson@gmail.com" },
  { first_name: "Bob", last_name: "Smith", email: "bob.smith@gmail.com" },
  { first_name: "Carlos", last_name: "Rivera", email: "carlos.rivera@gmail.com" },
  { first_name: "Diana", last_name: "Lee", email: "diana.lee@gmail.com" },
  { first_name: "Ethan", last_name: "Brown", email: "ethan.brown@yahoo.com" },
  { first_name: "Fatima", last_name: "Hassan", email: "fatima.hassan@yahoo.com" },
  { first_name: "George", last_name: "Wilson", email: "george.wilson@outlook.com" },
  { first_name: "Hannah", last_name: "Chen", email: "hannah.chen@outlook.com" },
  { first_name: "Ivan", last_name: "Petrov", email: "ivan.petrov@email.com" },
  { first_name: "Julia", last_name: "Martinez", email: "julia.martinez@email.com" }
]

regular_users.each do |attrs|
  seed_user(attrs.merge(
              password: "User@123!",
              password_confirmation: "User@123!",
              role: :user
            ))
end

if Rails.env.development? || Rails.env.staging?
  puts "\n--- QA / TEST ACCOUNTS ---"

  seed_user(
    first_name: "QA",
    last_name: "Admin",
    email: "qa.admin@test.com",
    password: "Test@1234!",
    password_confirmation: "Test@1234!",
    role: :admin
  )

  seed_user(
    first_name: "QA",
    last_name: "Business",
    email: "qa.business@test.com",
    password: "Test@1234!",
    password_confirmation: "Test@1234!",
    role: :business
  )

  seed_user(
    first_name: "QA",
    last_name: "User",
    email: "qa.user@test.com",
    password: "Test@1234!",
    password_confirmation: "Test@1234!",
    role: :user
  )
end

puts "\n#{'=' * 60}"
puts "  SEED SUMMARY"
puts "#{'=' * 60}"
puts "  Total Users:    #{User.count}"
puts "  Admins:         #{User.admins.count}"
puts "  Business:       #{User.businesses.count}"
puts "  Regular Users:  #{User.regular_users.count}"
puts "#{'=' * 60}"
puts "\n  TEST CREDENTIALS:"
puts "  Admin    -> admin@myapp.com         / Admin@123!"
puts "  Business -> techcorp@business.com   / Business@123!"
puts "  User     -> alice.johnson@gmail.com / User@123!"
puts "#{'=' * 60}\n"

load Rails.root.join("db/seeds/government_notices.rb")
