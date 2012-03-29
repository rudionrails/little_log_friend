### LittleLogFriend is no longer actively maintained in favour to: [Yell - Your Extensible Logging Library](https://github.com/rudionrails/yell)

Although it is still a good replacement for Ruby's standard Logger in the 
smaller scale, you might want to take a look at [Yell](https://github.com/rudionrails/yell), 
or jump directly into the [Wiki](https://github.com/rudionrails/yell/wiki), 
for a logging solution with some extra whiz-bang!




# LittleLogFriend

LittleLogFriend sets your standard logger to a more readable format, like so:

```ruby
logger = Logger.new STDOUT

logger.info 'hello world'
#=> 2009-01-14 10:10:10 [ INFO] 15356 : hello world
```

The format is: DATE TIME [ LOG LEVEL ] PID : MESSAGE


## Installation

### The Gem Version

System wide:

```console
gem install little_log_friend
```

Or in your Gemfile:

```ruby
gem 'little_log_friend'
```

You should create an initializer file in order to get LittleLogFriend to work for you, like so:

```ruby
# config/initializers/little_log_friend.rb (create it if not present)
require 'little_log_friend
```


### The Plugin Version

```console
script/plugin install git://github.com/rudionrails/little_log_friend.git
```

You don't need to specifically require little_log_friend, the init.rb of the plugin will take care of it.


## Usage

LittleLogFriend will automatically enhance your standard logger with a nicer 
log formatting - nothing more. Instead of the regular format, you will see 
every log message starting with a nice timestamp and a better formatted message 
altogether. This will help you to trace your logs much easier in case something 
goes happens. Moreover, if you are using monitoring tools to 
detect errors in you logs so that they send out notifications to your sysadmin, 
a unified logging format will significantly ease this process.

Additionally to that, you can add this to your environment.rb: 

```ruby
LittleLogFriend.colorize!
```

This will enable colorized log output (under Unix). Every log level will appear
in a different color to ease log interpretation. Here are the colors for each
severity:

  debug   => green
  info    => white
  warn    => yello
  error   => red
  fatal   => purple
  unknown => white
  default => default of the console / none


Also, you can override the default color settings, like so: 

```ruby
LittleLogFriend.colorize!( :info => "\033[01;36m" ) # cyan for Unix
```

Specify the keys as explained above for the default severity colors.


## Additional Notes

LittleLogFriend is not meant to be a fully featured log solution, but it's
supposed to help in the smaller scale and especially when developing.

Also, you probably don't want to use colorized logging in production mode, as it
will be very difficult to read the log file on a remote server with all the color
information in it.


Copyright (c) 2009 - 2012 Rudolf Schmidt, released under the MIT license
