module LittleLogFriend

  class Formatter < Logger::Formatter

    @@colorize = false

    Format = "%s [%5s] %d %s: %s"

    @@colors = {
      'DEBUG'   => "\e[1;32;1m", # green
      'INFO'    => "\e[0;1m",    # white
      'WARN'    => "\e[1;33;1m", # yello
      'ERROR'   => "\e[1;31;1m", # red
      'FATAL'   => "\e[1;35;1m", # punk, yes PUNK!
      'UNKNOWN' => "\e[0;1m",    # white
      'DEFAULT' => "\e[0m"       # NONE
    }

    def initialize
      super
      @datetime_format = "%Y-%m-%d %H:%M:%S"
    end

    def self.colorize!( options = {} )
      @@colorize = true
      options.each { |key, value| @@colors[key.to_s.upcase] = value }
    end

    # This method is invoked when a log event occurs
    def call ( severity, time, progname, msg )
      msg = Format % [format_datetime(time), severity, $$, progname, msg2str(msg)]
      msg = @@colors[severity] + msg + @@colors['DEFAULT'] if @@colorize
      msg << "\n"
    end

    def number_to_severity ( n )
      severities = [:debug, :info, :warn, :error, :fatal, :unknown]
      severities[n]
    end
  end

end