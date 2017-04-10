module Joaquin
  class Print

    STDOUT.sync = true
    STDERR.sync = true

    def self.debug(message)
      # Skip if Debug mode is disabled
      return unless Joaquin.options.verbose

      Print.build_string(Joaquin::PRINT_TYPE_DEBUG, message).each do |string|
        STDOUT.puts(string)
      end
    end

    def self.info(message)
      Print.build_string(Joaquin::PRINT_TYPE_INFO, message).each do |string|
        STDOUT.puts(string)
      end
    end

    def self.success(message)
      Print.build_string(Joaquin::PRINT_TYPE_INFO, message.green).each do |string|
        STDOUT.puts(string)
      end
    end

    def self.warning(message)
      Print.build_string(Joaquin::PRINT_TYPE_INFO, message.yellow).each do |string|
        STDOUT.puts(string)
      end
    end

    def self.error(message)
      Print.build_string(Joaquin::PRINT_TYPE_ERROR, message.red).each do |string|
        STDERR.puts(string)
      end
    end

    private

    def self.build_string(type, string)
      string_components = string.dup.split('\n')
      date = "[#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}]".magenta
      strings = []
      string_components.each do |component|
        strings << "#{date} #{type} #{string}"
      end
      return strings
    end

  end
end
