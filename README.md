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
# -*- coding: utf-8 -*-
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

Extend your controllers with IB module:

```ruby
class SuperController < UIViewController

  extend IB

  # define attribute accessor
  attr_accessor title

  # define ib outlet
  ib_outlet :title, UILabel

  # define action method
  def ontouch button
    title.text = "Touched!!!"
  end

  # define ib action 
  ib_action :ontouch
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
