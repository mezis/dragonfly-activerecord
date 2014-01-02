# dragonfly-activerecord

[![Gem Version](https://badge.fury.io/rb/dragonfly-activerecord.png)](http://badge.fury.io/rb/dragonfly-activerecord)
[![Build Status](https://travis-ci.org/mezis/dragonfly-activerecord.png?branch=master)](https://travis-ci.org/mezis/dragonfly-activerecord)
[![Dependency Status](https://gemnasium.com/mezis/dragonfly-activerecord.png)](https://gemnasium.com/mezis/dragonfly-activerecord)
[![Code Climate](https://codeclimate.com/github/mezis/dragonfly-activerecord.png)](https://codeclimate.com/github/mezis/dragonfly-activerecord)

Provides a data store for [Dragonfly](https://github.com/markevans/dragonfly),
backed by ActiveRecord.

Requires a Rails application using Dragonfly 1.0+.


## Why?

Because there's a fat chance our app already has a database. Why bother with S3
when your DB can do the job just fine?

Yes, storing files in a relational database may be a bad idea at scale, but for
many use cases (up to a few gigabytes of storage) it really eases the
maintenance burden.


## Installation

Add this line to your application's Gemfile:

    gem 'dragonfly-activerecord'

Create a migration:

    $ rails generate migration add_dragonfly_storage

Edit the migration file:

```ruby
require 'dragonfly-activerecord/migration'

class AddDragonflyStorage < ActiveRecord::Migration
  include Dragonfly::ActiveRecord::Migration
end
```

Run the migration:

    $ rake db:migrate

Configure Dragonfly itself (in `config/initializers/dragonfly.rb`, typically):

```ruby
require 'dragonfly-activerecord/store'

Dragonfly.app.configure do
  # ... your existing configuration here
  datastore Storage::DataStore.new
end
```

... and you're good to go!


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
