# IB

RubyMotion interface builder support (yes, with outlets)

<a href='http://spellhub.com/projects/project/7'><img src="http://spellhub.com/projects/status/7" height="18"></a>
[![Build Status](https://travis-ci.org/yury/ib.png?branch=master)](https://travis-ci.org/yury/ib)

[**Change Log**](https://github.com/yury/ib/wiki/Change-Log)

## Installation

Add this line to your application's Gemfile:

    gem 'ib'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ib

Or use RubyMotion [templates by @infiniteNIL](https://github.com/infiniteNIL/RubyMotionTemplates)

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

**NOTE:** If you include methods and attributes from module, you can use `ib_outlet` and `ib_action` to make them visible in Interface Builder

```ruby
module TouchLogger
  outlet :my_button, UIButton

  def controlTouched sender
    puts "touched"
  end
end

class LogController < UIViewController
  extend IB

  include TouchLogger

  ib_outlet :my_button
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

### Using Interface Builder

Running `rake ib` will create a ib.xcodeproj in the root of your app and open XCode. You can create Storyboards or nibs, and save them in your `resources` directory in order to be picked up by RubyMotion.

Everytime you make a change in your ruby files (like adding a new outlet or action method) you have to run `rake ib` in order to let Interface Builder see the changes.

**Tip** : add ib.xcodeproj to your .gitignore

### How it works

This gem parses your Ruby code and generates two Objective-c files (Stub.m and Stub.h) which are populated with the classes, methods and outlets you have defined. This is necessary for Interface Builder to bind outlets and actions to your code.

### Warning

Various versions of the `ib` gem are incompatible with advancing versions of Xcode. If you are not seeing your outlets and actions in Interface Builder, it's possible you have such a mismatch. Here's a way to find out if this might be true:

* Check the version of the gem by doing `gem list|grep ib` from the command line.
* Compare the version listed with that in the most current gem (assuming you are using a current version of Xcode). You can find this in `lib/ib/version.ib`

If you find your version of the `ib` gem is not current, try `bundle update ib`. If this does not resolve the problem, the conflict can be in required versions of Thor. For example, Guard requires a particular version of Thor and `ib` does not specify. You may find removing Guard will allow your bundle update to bring `ib` up to the current version.

> Further note: If you are working on a current app and are used to creating your views programmatically, read on. If you're an Interface Builder ninja, nevermind(tm). It is important that you set your File's Owner in Interface Builder *to the controller you are using*. Remember, *File's Owner*, not View. Next, drag the `View` outlet in File's owner to the view you should have by now created. This will reduce the traffic on Google looking up "how come I can't get my nib hooked up right?" And remember, because File's Owner is the controller, you will bind all outlets and actions to File's Owner, so look there for these magic thingies.

# Sample app

Here is [sample app](https://github.com/yury/ibsample)

1. clone it
2. run `bundle`
3. run `rake ib` to change story board
4. run `rake` to run app in simulator

**Note** : this app is build for iOS 6.0

# Another Sample app

Here is [another sample app](https://github.com/hqmq/whereami)

# OS X Sample app

Here is [OS X sample app](https://github.com/MarkVillacampa/motion-osx-ib)

You can play around with it in the same way as the Sample app above. This sample uses a single xib file rather than a storyboard.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
