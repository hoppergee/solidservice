# SolidService

[![CI](https://github.com/hoppergee/solidservice/actions/workflows/main.yml/badge.svg)](https://github.com/hoppergee/solidservice/actions/workflows/main.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/625ef769e60ab39159ce/maintainability)](https://codeclimate.com/github/hoppergee/solidservice/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/625ef769e60ab39159ce/test_coverage)](https://codeclimate.com/github/hoppergee/solidservice/test_coverage)

Servcie object with a simple API.

```ruby
result = ASolidService.call(any: 'thing', you: 'like')
result.success? #=> true
result.fail? #=> false
```

- One service per action
- Service only has one public method `.call` with a hash input argument
- The `.call` always return a `State` object. You can ask the state object the execution result

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
$ bundle add solidservice
```

Or manually add it in Gemfile

```ruby
gem 'solidservice'
```


## Basic Usage

Here is an example for Rails app.

1. Create a `services` folder

```bash
mkdir app/services
```

2. Create the service you want

```ruby
class UpdateUser < SolidService::Base
  def call
    if user.update(user_params)
      success!(user: user)
    else
      fail!(user: user)
    end
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    @user ||= params[:user_params]
  end
end
```

3. Use this service in controller

```ruby
class UsersController < ApplicationController
  def update
    result = UpdateUser.call(
      id: params[:id],
      user_params: params.require(:user).permit(:email)
    )

    if result.success?
      redirect_to root_path
    else
      @user = result.user
      render :edit
    end
  end
end
```

## Only 4 DSL in the `call` method

- `success!` - Success the servcie immediately, any code after it won't be execute (Recommend)
- `success` - Just update the state to success
- `fail!` - Fail the service immediately, any code after it won't be execute (Recommend)
- `fail` - Just update the state to fail

## How to return other data

You can send data with state object like this:

```ruby
success!(user: user)
success(user: user, item: item)
fail!(email: email, error: error)
fail(error: error)
```

Then we can get those data on the result:

```ruby
result = ExampleService.call
result.success? #=> true
result.user
result.item

result.success? #=> false
result.error
result.email
```

## Servcie success by default

If you don't call above 4 methods, the servcie will be marked as success by default. It's some those service which just want to execute some action and don't want to return any thing.

```ruby
class ACommandService < SolidService::Base
  def call
    # Do some actions that don't need to return anything
  end
end

result = ACommandService.call
result.success? #=> true
```

## Use service in service with `call!`

Sometimes, we want to use a service in another service, but don't want to doing `if/else` on the state object everywhere, then we can use `call!` for the inner service. Then the service will raise error on failure.

```ruby
class Action2 < SolidService::Base
  def call
    fail!(error: StandardError.new('something wrong'))
  end
end

class Action1 < SolidService::Base
  def call
    Action2.call!
  end
end

result = Action1.call
result.fail? #=> true
result.error #=> #<StandardError: something wrong>
```


## Development

```bash
bundle install
meval rake # Run test
meval -a rake # Run tests against all Ruby versions and Rails versions
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hoppergee/solidservice. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hoppergee/solidservice/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SolidService project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hoppergee/solidservice/blob/master/CODE_OF_CONDUCT.md).
