require 'logger'

module LittleLogFriend
  
  VERSION = "0.1.1"
  
  def self.colorize!; Formatter.colorize!; end  
  
  class Formatter < Logger::Formatter
    
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
    
    def initialize
      super
      @datetime_format = "%Y-%m-%d %H:%M:%S"
    end

    def self.colorize!; @@colorize = true; end
    
    # This method is invoked when a log event occurs
    def call ( severity, time, progname, msg )
      msg = Format % [format_datetime(time), severity, $$, progname, msg2str(msg)]
      
      msg = COLORS[severity] + msg + COLORS['DEFAULT'] if @@colorize
      msg << "\n"
    end
    
    def number_to_severity ( n )
      case n
        when 0 : 'DEBUG'
        when 1 : 'INFO'
        when 2 : 'WARN'
        when 3 : 'ERROR'
        when 4 : 'FATAL'
        when 5 : 'UNKNOWN'
      end
    end
  end
  
end

# Overload the default logger class 
class Logger  
  
  alias :old_formatter :formatter if method_defined?(:formatter)
  
  def formatter
    @formatter ||= LittleLogFriend::Formatter.new
  end
  
  
  private

  alias :old_format_message :format_message if method_defined?(:format_message)

  def format_message(severity, datetime, progname, msg)
    (formatter || @default_formatter).call(severity, datetime, progname, msg)
  end
  
end

# Overload the BufferedLogger in Rails
module ActiveSupport
  class BufferedLogger    
    
    alias :old_formatter :formatter if method_defined?(:formatter)
    
    def formatter
      @formatter ||= LittleLogFriend::Formatter.new
    end
    
    
    alias :old_add :add if method_defined?(:add)
    
    # We need to overload the add method. Basibally it is the same as the 
    # original one, but we add our own log format to it.
    def add(severity, message = nil, progname = nil, &block)
      return if @level > severity
      message = (message || (block && block.call) || progname).to_s
      message = formatter.call(formatter.number_to_severity(severity), Time.now.utc, progname, message)
      message = "#{message}\n" unless message[-1] == ?\n
      buffer << message
      auto_flush
      message
    end
    
  end
end

