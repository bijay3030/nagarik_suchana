# Seed Government Notices
# Idempotent: re-running updates existing records by title.

return unless defined?(GovernmentNotice)

admin = User.find_by(email: "admin@myapp.com") || User.admins.first
unless admin
  puts "[SKIP] Government notices seed skipped: no admin user found."
  return
end

seed_notices = [
  {
    title: "Revised Municipal Tax Filing Window",
    description: "The filing window for municipal tax returns has been extended by 30 days. All businesses must submit updated declarations before the revised deadline.",
    category: "Tax",
    effective_date: Date.current + 7.days,
    status: :published,
    published_at: Time.current - 2.days
  },
  {
    title: "Public Health Advisory: Seasonal Flu Preparedness",
    description: "Health department advises institutions to maintain hygiene stations and follow updated outbreak response guidelines for the upcoming season.",
    category: "Health",
    effective_date: Date.current + 3.days,
    status: :published,
    published_at: Time.current - 1.day
  },
  {
    title: "Infrastructure Maintenance Notice for Ring Road Section B",
    description: "Scheduled maintenance work will impact traffic flow on Ring Road Section B. Alternate routes and lane restrictions will be active during the maintenance period.",
    category: "Infrastructure",
    effective_date: Date.current + 10.days,
    status: :draft,
    published_at: nil
  },
  {
    title: "Environmental Compliance Self-Assessment Update",
    description: "Organizations must complete the updated environmental self-assessment checklist and submit declarations through the compliance portal.",
    category: "Environmental",
    effective_date: Date.current + 14.days,
    status: :archived,
    published_at: nil
  }
]

seed_notices.each do |attrs|
  notice = GovernmentNotice.unscoped.find_or_initialize_by(title: attrs[:title])
  notice.assign_attributes(attrs)
  notice.creator ||= admin
  notice.updater = admin
  notice.deleted_at = nil if notice.deleted_at.present?

  if notice.save
    puts "[OK] Notice seeded: #{notice.title} (#{notice.status})"
  else
    puts "[ERROR] Notice seed failed: #{notice.title} -> #{notice.errors.full_messages.join(', ')}"
  end
end

puts "[DONE] Government notices seeded: #{GovernmentNotice.count} total"
