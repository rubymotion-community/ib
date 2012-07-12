# IB 

rubymotion interface builder support (yes, with outlets)

## Installation

Add this line to your application's Gemfile:

    gem 'ib'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ib

In your Rake file:

```ruby

$:.unshift("/Library/RubyMotion/lib")  
require 'motion/project'  

# if you use bundler
require 'bundler/setup'  
Bundler.setup

# require 'ib tasks'
require 'ib/tasks'


Motion::Project::App.setup do |app|
  # ...
  app.files.unshift IB::PATH # add ib module
end

```

## Usage

Generate controller with folllowing command:

```
ib_controller_generator Hello --outlets=scroller:UIScrollView btn_hello:UIButton --actions say_hello --accessors data_source
```

The generated file:

#### /app/controllers/hello_controller.rb
```ruby
class HelloController < UIViewController
  extend IB

  ## define accessors
  attr_accessor :data_source, :view, :scroller, :htn_hello

  ## define ib outlets
  ib_outlet :scroller, UIScrollView
  ib_outlet :btn_hello, UIButton

  ## define actions
  def say_hello(sender)
    # TODO Implement action here
  end

  ## define ib action 
  ib_action :say_hello

end
```

Run `rake design` create Storyboard or nibs (put them in resources folder) and you will be able to bind outlets and actions to your ruby code.

**Note** : add ui.xcodeproj to your .gitignore

# Sample app

Here is [sample app](https://github.com/yury/ibsample)

1. clone it 
2. run `bundle`
3. run `rake design` to change story board
4. run `rake` to run app in simulator

**Note** : this app is build for iOS 6.0 beta 2

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
