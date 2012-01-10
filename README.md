# Rails Blog Engine

**Pre-beta release.  Public APIs may change.**

Add a blog to any Rails 3.1 site using `rails_blog_engine`.  First, add the
following line to your `Gemfile`:

    gem 'rails_blog_engine'

...and run:

    bundle install
    rails generate rails_blog_engine:install
    rake db:migrate

Check the configuration in the newly-generated
`config/initializers/rails_blog_engine.rb` and tweak as necessary.

If you're using Devise, or another framework which defines `current_user`
on `ActionController::Base`, then all you need to do is add a `blog_admin?`
method to your user model:

    class User
      # ...other stuff here...
    
      # Return true if the user is allowed to post to the blog,
      # moderate comments, etc.
      def blog_admin?
        # Your code here.
      end
    end

You should now be able to access your blog at `http://0.0.0.0:3000/blog`
and start posting!

## Philosophy and planned features

`rails_blog_engine` should...

* ...be installable in under 5 minutes.
* ...be simple and easily hackable.
* ...be opinionated.
* ...be customized by overriding templates or forking the source, not by
  adding configuration options.
* ...be secure.
* ...follow all white-hat SEO best practices.
* ...have excellent unit test coverage, including tests for JavaScript.

CoffeeScript, SCSS and other standard Rails 3.1 features are fair game, as
are RSpec, HAML and CanCan.

The following features are on my wishlist:

* More generators to aid customization
* Caching
* A basic editor: Auto-save, with preview and a "Publish" button

In other words, we want just enough features to make blogging pleasant, and
nothing more.

## What if I'm don't have `ActionController::Base#current_user`?

Add something like the following to
`config/initializers/rails_blog_engine.rb`:

    class RailsBlogEngine::ApplicationController
      def current_user
        # Check session, etc., here.
      end
    end

Please open an issue if you have any questions or problems.

## Setting up titles and <head> tags

To set up titles, add the two following `yield` lines to the `<head>` tag
in your `app/views/layouts/application.html.erb`:

    <head>
      <title><%= yield(:title) %></title>
      <%= yield(:head) %>
      <!-- etc. -->
    </head>

## Turning on the spam filter

To enable the spam filter, create an Akismet account at http://akismet.com/
and set the environment variables `RAKISMET_KEY` and `RAKISMET_URL`.  If
you're deploying to Heroku, you can do this using:

    heroku config:add RAKISMET_KEY="mykey" RAKISMET_URL="http://example.com/"

On your development machine, you can create a file named `.env` in the root
directory of your project, and specify the variables as follows:

    RAKISMET_KEY=mykey
    RAKISMET_URL=http://example.com/

Then launch your application using the `foreman start` command.  This will
require adding the `foreman` gem to your `Gemfile`, and creating a
`Procfile`.

## Syntax highlighting

If you want to be able to display source code snippets with syntax
highlighting, you'll need to add the following line to your `Gemfile`:

    gem 'pygments', :git => 'https://github.com/nathany/pygments-gem.git'

Next, run `bundle install` and restart your server.  This will allow
you to include code snippets in your posts as follows:

    <filter:code lang="ruby">
    def hello
      puts "Hello!"
    end
    </filter:code>

You can also add your own filters.  Documentation and generators should be
available soon.

 
