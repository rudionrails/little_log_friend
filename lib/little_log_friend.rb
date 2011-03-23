require 'logger'

module LittleLogFriend

  autoload :Formatter, File.dirname(__FILE__) + '/little_log_friend/formatter'

  
  def self.colorize!( *args )
    Formatter.colorize!( *args )
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

