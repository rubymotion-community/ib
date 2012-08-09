# IB 

rubymotion interface builder support (yes, with outlets)

[**Change Log**](https://github.com/yury/ib/wiki/Change-Log)

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
require 'bundler' 
Bundler.require

# if you are not using bundler
require 'rubygems'
require 'ib'

Motion::Project::App.setup do |app|
  # ...
end

```

## Usage

### Manual Way

extend your class with IB module

```ruby
class HelloController < UIViewController
  extend IB

  # define ib outlet
  outlet :title, UILabel # @property IBOutlet UILabel * title;
  outlet :untyped_label  # @property IBOutlet id untyped_label;
  
  # define ib outlet collection
  outlet_collection :labels, UILabel # @property IBOutletCollection(UILabel) NSArray * labels;

  # define ib action
  def someAction sender
  end
end
```

**NOTE:** If you include methods and attributes from module, you can use `ib_outlet` and `ib_action` to make them visible in designer

```ruby
module TouchLogger
  def controlTouched sender
    puts "touched"
  end
end

class LogController < UIViewController
  extend IB

  include TouchLogger

  ib_action :controlTouched
end
```

### Generators Way
Generate controller with folllowing command:

```
ib c Hello UIViewController \
  --outlets scroller:UIScrollView btn_hello: \
  --actions say_hello \
  --accessors data_source
```

The generated file:

#### /app/controllers/hello_controller.rb
```ruby
class HelloController < UIViewController
  extend IB

  attr_accessor :data_source

  ## ib outlets
  outlet :scroller, UIScrollView
  outlet :btn_hello

  def say_hello(sender)
    # TODO Implement action here
  end

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
