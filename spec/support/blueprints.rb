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

RailsBlogEngine::Comment.blueprint do
  author_byline { "User #{sn}" }
  body { "Comment body" }
end

# Devise User model for our dummy application.
User.blueprint do
  email { "user#{sn}@example.com" }
  password { "password" }
  password_confirmation { "password" }
end
