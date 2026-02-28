if Rails.env.development?
  ActiveSupport::Notifications.subscribe('sql.active_record') do |_name, start, finish, _id, payload|
    sql = payload[:sql].to_s
    next unless sql.match?(/\A\s*(SELECT|INSERT|UPDATE|DELETE)/i)

    duration = ((finish - start) * 1000.0).round(2)
    next unless duration > 100

    Rails.logger.warn("SLOW QUERY (#{duration}ms): #{sql}")
  end
end
