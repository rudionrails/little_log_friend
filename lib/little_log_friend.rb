require 'logger'

class LittleLogFriend
  
  @@colorize = false

  Format = "%s [%5s] %d %s: %s"
  
  COLORS = {
    'DEBUG'   => "\e[1;32;1m", # green
    'INFO'    => "\e[0;1m",    # white
    'WARN'    => "\e[1;33;1m", # yello
    'ERROR'   => "\e[1;31;1m", # red
    'FATAL'   => "\e[1;35;1m", # punk, yes PUNK!
    'UNKNOWN' => "\e[0;1m",    # white
    'DEFAULT' => "\e[0m"       # NONE
  } unless defined? COLORS
  
  def self.message_for(severity, time, progname, msg)
    msg = Format % [time.strftime("%Y-%m-%d %H:%M:%S"), severity, $$, progname, msg]
    
    msg = COLORS[severity] + msg + COLORS['DEFAULT'] if @@colorize
    msg + "\n"
  end

  def self.colorize!; @@colorize = true; end
  
end

# Overload the default logger class 
class Logger  
  class Formatter
    
    # we overload the method to output our own log format
    def call(severity, time, progname, msg)
      LittleLogFriend.message_for(severity, time, progname, msg2str(msg))
    end
    
  end
end

# Overload the BufferedLogger
module ActiveSupport
  class BufferedLogger
    
    # adding level_to_s to the already existing Severity module
    module Severity
      def level_to_s(level)
        case level
        when 0 : 'DEBUG'
        when 1 : 'INFO'
        when 2 : 'WARN'
        when 3 : 'ERROR'
        when 4 : 'FATAL'
        when 5 : 'UNKNOWN'
        end
      end
    end
    
    # We need to overload the add method. Basibally it is the same as the 
    # original one, but we add our own log format to it.
    def add(severity, message = nil, progname = nil, &block)
      return if @level > severity
      message = (message || (block && block.call) || progname).to_s
      message = LittleLogFriend.message_for(level_to_s(severity), Time.now.utc, progname, message)
      @buffer << message
      auto_flush
      message
    end
    
  end
end

