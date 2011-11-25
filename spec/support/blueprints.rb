require 'machinist/active_record'

RailsBlogEngine::Post.blueprint do
  title { "Post #{sn}" }
  body { "Body text" }
  permalink { "permalink-#{sn}" }
  author { User.make }
end

RailsBlogEngine::Post.blueprint(:published) do
  state { "published" }
  published_at { Time.now }
end

# Devise User model for our dummy application.
User.blueprint do
  email { "user#{sn}@example.com" }
  password { "password" }
  password_confirmation { "password" }
end

RailsBlogEngine::Comment.blueprint do
  # Attributes here
end
