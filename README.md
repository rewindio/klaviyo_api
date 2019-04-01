# KlaviyoAPI

[![Build Status](https://travis-ci.org/rewindio/klaviyo_api.svg?branch=master)](https://travis-ci.org/rewindio/klaviyo_api)

The best way to consume Klaviyo's v1 & v2 APIs!

## Installation

### Add this line to your application's Gemfile

```ruby
gem 'klaviyo_api'
```

## Usage

### Basic Account object

```ruby
# frozen_string_literal: true

require 'klaviyo_api'

class Account
  attr_accessor :access_token

  def initialize(access_token)
    @access_token = access_token
  end

  def with_klaviyo_session(█)
    KlaviyoAPI::Session.temp access_token, █
  end
end

account = Account.new 'xxxyyyzzz'
```

### GET `/`

```ruby
account.with_klaviyo_session { KlaviyoAPI::AccountInformation.find '' }
```

### GET `/lists`

```ruby
account.with_klaviyo_session { KlaviyoAPI::List.all }
```

## Development

After checking out the repository, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests.

You can also run `bin/console` for an interactive prompt that will allow you to experiment. You can create a file in the root of the project called `dev-config.yml` and add your API key to it:

```
api_key: <your-api-key>
```

This will tell the console to pre-authenticate the Klaviyo session, making it easier to test.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/rewindio/klaviyo_api>.
