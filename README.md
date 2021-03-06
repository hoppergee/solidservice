# SolidService

[![CI](https://github.com/hoppergee/solidservice/actions/workflows/main.yml/badge.svg)](https://github.com/hoppergee/solidservice/actions/workflows/main.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/625ef769e60ab39159ce/maintainability)](https://codeclimate.com/github/hoppergee/solidservice/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/625ef769e60ab39159ce/test_coverage)](https://codeclimate.com/github/hoppergee/solidservice/test_coverage)

A service pattern with a simple API.

```ruby
result = ASolidService.call(any: 'thing', you: 'like')
result.success? #=> true
result.fail? #=> false
```

- One service per action
- Service only has one public method `.call` with a hash input argument
- The `.call` always return a `State` object. You can ask the state object the execution result

Check the [Q&A](#qa) for popular questions like:

- Is this gem has any different than interactor, simple_command and dry-monads?
- You use rescue to handle control flow? That's a bad idea.

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
    @user_params ||= params[:user_params]
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

- `success!` - Success the service immediately, any code after it won't be execute (Recommend)
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

## service success by default

If you don't call above 4 methods, the service will be marked as success by default. When some services which just want to execute some actions and don't want to return anything, go ahead, SolidService will take care of it.

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

## Q&A

### Is this gem has any different than interactor, simple_command and dry-monads?

Here are some the key advantages:

- It's much simple then other service like pattern.
- You can master it in a few of seconds and start to use it in real projects.
- Easy to write concise, readable and maintainable code with only 4 DSL
- Unify input and output but without any restrictions
  - The input is a hash called `params`. It's Rails dev friendly, use it just like a controller
  - The output is an state object with hash data. Call any methods on it, it won't raise error on data missing.

### You use rescue to handle control flow? That's a bad idea.

**This gem doesn't force you to do that.** Those rescue handle on `Success` and `Failure` only work when you use `success!` and `fail!`. You can only use `success` and `fail` if you don't like the rescue pattern.

I use it for a very practical reason. I believe many people have met this issue in the controller:

```ruby
class ExampleController < ApplicationController
  def create
     if a_condition
        render :a_page and return
     end

     # ......
  end
end
```

I meet the same issue in service:

```ruby
class ExampleService < SolidService::Base
  def call
    if check_1_failed
      fail(user: user) and return
    end

    if check_2_failed
      fail(user: user) and return
    end

    # ...
  end
end
```

I hate this. It's very low readability. So I comes up with with the rescue way to end the action immediately when I call `success!` and `fail!`

```ruby
class ExampleService < SolidService::Base
  def call
    fail!(user: user) if check_1_failed
    fail!(user: user) if check_2_failed

    # ...
  end
end
```

I think it's much better. So you see, the `rescue` is for `success!` and `fail!` only. You can still use `success` and `fail`. Even me, I did have a few circumstances need me to call success multiple times, then I will use it also.

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
