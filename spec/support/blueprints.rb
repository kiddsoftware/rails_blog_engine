require 'machinist/active_record'

RailsBlogEngine::Post.blueprint do
  title { "Post #{sn}" }
  body { "Body text" }
  permalink { "permalink-#{sn}" }
  author { User.make }
end

# Devise User model for our dummy application.
User.blueprint do
  email { "user#{sn}@example.com" }
  password { "password" }
  password_confirmation { "password" }
end
