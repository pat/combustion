# Combustion

Combustion is a library to help you test your Rails Engines in a simple and effective manner, instead of creating a full Rails application in your spec or test folder.

It allows you to write your specs within the context of your engine, using only the parts of a Rails app you need.

## Usage

Get the gem into either your gemspec or your Gemfile, depending on how you manage your engine's dependencies:

```ruby
# gemspec
gem.add_development_dependency 'combustion', '~> 0.5.3'

# Gemfile
gem 'combustion', '~> 0.5.3', :group => :test
```

In your `spec_helper.rb`, get Combustion to set itself up - which has to happen before you introduce `rspec/rails` and - if being used - `capybara/rails`. Here's an example within context:

```ruby
require 'rubygems'
require 'bundler/setup'

require 'combustion'
require 'capybara/rspec'

Combustion.initialize! :all

require 'rspec/rails'
require 'capybara/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
```

You'll also want to run the generator that creates a minimal set of files expected by Rails - run this in the directory of your engine:

```shell
combust

# or, if bundling with the git repo:
bundle exec combust
```


What Combustion is doing is setting up a Rails application at `spec/internal` - but you only need to add the files within that directory that you're going to use. Read on for some detail about what that involves.

If you want to use Cucumber, I recommend starting with [these notes in issue #16](https://github.com/pat/combustion/issues/16) from Niklas Cathor.

### Configuring a different test app directory

If you want your app to be located somewhere other than `spec/internal`, then make sure you configure it before you call `Combustion.initialize!`:

```ruby
Combustion.path = 'spec/dummy'
Combustion.initialize! :all
```


### Configuring which Rails modules should be loaded.

By default, Combustion doesn't come with any of the Rails stack. You can customise this though - just pass in what you'd like loaded to the `Combustion.initialize!` call:

```ruby
Combustion.initialize! :active_record, :action_controller,
                       :action_view, :sprockets
```


And then in your engine's Gemfile:

```ruby
group :test do
  gem 'activerecord'
  gem 'actionpack' # action_controller, action_view
  gem 'sprockets'
end
```

Make sure to specify the appropriate version that you want to use.

ActiveSupport and Railties are always loaded, as they're an integral part of Rails.

### Using Models and ActiveRecord

If you're using ActiveRecord, then there are two critical files within your internal Rails app at `spec/internal` that you'll need to modify:

* config/database.yml
* db/schema.rb

Both follow the same structure as in any normal Rails application - and the schema file lets you avoid migrations, as it gets run whenever the test suite starts. Here's a quick sample (note that tables are overwritten if they already exist - this is necessary):

```ruby
ActiveRecord::Schema.define do
  create_table(:pages, :force => true) do |t|
    t.string :name
    t.text   :content
    t.timestamps
  end
end
```

### Configuring Combustion to initialise the test db from a .sql file instead of schema.rb

Name the file structure.sql and configure Combustion to use it before initialising:

```ruby
Combustion.schema_format = :sql
Combustion.initialize! :all
```

Any models that aren't provided by your engine should be located at `spec/internal/app/models`.

### Using ActionController and ActionView

You'll only need to add controllers and views to your internal Rails app for whatever you're testing that your engine doesn't provide - this may be nothing at all, so perhaps you don't even need `spec/internal/app/views` or `spec/internal/app/controllers` directories.

However, if you're doing any testing of your engine's controllers or views, then you're going to need routes set up for them - so modify `spec/internal/config/routes.rb` accordingly:

```ruby
Rails.application.routes.draw do
  resources :pages
end
```

Just like in a standard Rails app, if you have a mounted engine, then its routes are accessible through whatever it has been loaded as.

### Customizing Rails application settings

If you would like to specify any Rails configuration parameter, you can do it without creating any environment file, simply passing a block to Combustion.initialize! like this:

```ruby
Combustion.initialize! :all do
  config.active_record.whitelist_attributes = false
end
```

Values given through the initialize! block will be set during Rails initialization proccess, exactly before the corresponding environment file inside `spec/internals/config/enviroments` is loaded (when that file exists), overriding Combustion's defaults.

Parameters defined in, for instance, `spec/internals/config/environments/test.rb`, would override Combustion's defaults and also config settings passed to initialize!.

### Using other Rails-focused libraries

Be aware that other gems may require parts of Rails when they're loaded, and this could cause some issues with Combustion's own setup. You may need to manage the loading yourself by setting `:require` to false in your Gemfile for the gem in question, and then requiring it manually in your spec_helper. View [issue #33](https://github.com/pat/combustion/issues/33) for an example with FactoryGirl.

### Environment and Logging

Your tests will execute within the test environment for the internal Rails app - and so logs are available at `spec/internal/log/test.log`. You should probably create that log directory so Rails doesn't complain.

### Rack it up

Once you've got this set up, you can fire up your test environment quite easily with Rack - a `config.ru` file is provided by the generator. Just run `rackup` and visit [http://localhost:9292](http://localhost:9292).

### Get your test on!

Now you're good to go - you can write specs within your engine's spec directory just like you were testing a full Rails application - models in `spec/models`, controllers in `spec/controllers`. If you bring Capybara into the mix, then the standard helpers from that will be loaded as well.

```ruby
require 'spec_helper'

describe Page do
  describe '#valid' do
    it 'requires a name' do
      # This is just an example. Go write your own tests!
    end
  end
end
```


## Compatibility

Developed for Rails 3.1 or better (including Rails 4) and Ruby 1.9 or better. It should work on any other Ruby, and possibly Rails 3.0, but will not work neatly with earlier versions of Rails.

You can also use Combustion with multiple versions of Rails to test compatibility across them. [Appraisal](https://github.com/thoughtbot/appraisal) is a gem that can help with this, and a good starting reference is the [Thinking Sphinx](https://github.com/pat/thinking-sphinx) test suite, which runs against [multiple versions](https://github.com/pat/thinking-sphinx/blob/master/Appraisals) of Rails.

## Limitations and Known Issues

Combustion is currently written with the expectation it'll be used with RSpec. I'd love to make this more flexible - if you want to give it a shot before I get around to it, patches are very much welcome.

I've not tried using this with Cucumber, but it should work in theory without too much hassle. Let me know if I'm wrong!

## Contributing

Contributions are very much welcome - but keep in mind the following:

* Keep patches in a separate branch
* Don't mess with the version or history file. I'll take care of that when the patch is merged in.

There are no tests - partly because Combustion was extracted out from the tests of HyperTiny's Dobro, and partly because there's not much code. Still, if you can find a clean way of testing this, that'd be fantastic.

## Credits

Copyright (c) 2011, Combustion is developed and maintained by Pat Allan, and is released under the open MIT Licence. Many thanks to HyperTiny for encouraging its development, and [all who have contributed patches](https://github.com/pat/combustion/contributors).
