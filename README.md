# Rails Blog Engine

**Pre-beta release.  Public APIs may change.**

Add a blog to any Rails 3.1 site using `rails_blog_engine`.  If you're
already using `cancan` for authorization, then add the following line to
your `Gemfile`:

    gem 'rails_blog_engine'

...and run:

    bundle install
    rails generate rails_blog_engine:install
    rake db:migrate

Then edit your `app/models/ability.rb` file to authorize reading and
writing the blog.  For example:

    class Ability
      include CanCan::Ability
      include RailsBlogEngine::Ability
      
      def initialize(user)
        # Everybody can read the blog, even if they're not logged in.
        can_read_blog
        
        # Test to see whether a user can manage the blog.  For example,
        # if you identify administrators using an 'admin?' flag, you
        # might write 'if user.admin?' instead.
        if user
          can_manage_blog
        end
      end
    end

You should now be able to access your blog at `http://0.0.0.0:3000/blog`
and start posting!

If you're not using CanCan, keep reading for setup instructions.

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

## What if I'm not already using CanCan?

You can still use `rails_blog_engine`!  First, install `rails_blog_engine`
as described above, and then add the following lines to your `Gemfile`:

    gem 'devise'  # Optional.
    gem 'cancan'

You don't have to use `devise`—you can use `rails_blog_engine` with the
authentication framework of your choice.  If you are using Devise, however,
you will now need to generate a user class:

    rails generate devise:install
    rails generate devise User

To prevent random members of the public from signing up for a user account,
edit `app/models/user.rb` and remove `:registerable`.  To create a new user,
you must now run the following command from the Rails console:

    User.create!(:email => "me@example.com", :password => "12345",
                 :password_confirmation => "12345")

(Alternatively, you keep `:registerable` on your `User` model, and add a
new field `admin?` which you set from the console.)

Once you have a working user model, you can generate a new
`app/models/ability.rb` file:

    rails generate cancan:ability

...and edit it as described above.

### How can I make this work without a Devise `User` class?

Basically, all CanCan cares about is whether your controller defines a
`current_ability` class.  So for example, if you don't use Devise, but the
currently logged-in administrator is available as `current_admin`, you can
edit `app/controllers/application_controller.rb` to override
`current_ability`:

    class ApplicationController < ActionController::Base
      # ...other stuff here...
      
      def current_ability
        @current_ability ||= ::Ability.new(current_admin)
      end
    end

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

 
