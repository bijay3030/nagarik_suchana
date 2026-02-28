class UserSerializer
  include JSONAPI::Serializer

  attributes :id,
             :email,
             :first_name,
             :last_name,
             :full_name,
             :role,
             :created_at

  attribute :full_name do |user|
    user.full_name
  end

  attribute :initials do |user|
    user.initials
  end
end
