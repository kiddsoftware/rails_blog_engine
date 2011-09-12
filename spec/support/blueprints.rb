require 'machinist/active_record'

RailsBlogEngine::Post.blueprint do
  title { "Post #{sn}" }
  body { "Body text" }
end
