require 'erb'

module Plugins

  class Category

    attr_accessor :directory, :identifier, :category_path, :subcategories, :plugins

    def initialize(directory, category_path = '')
      @directory = directory
      @identifier = File.basename(directory)
      @category_path = category_path
      @plugins = []
      @subcategories = []
      Dir.new(directory).each do |entry|
        entry_path = File.join(directory, entry)
        if File.file?(entry_path) && File.extname(entry) == '.rb' && entry != 'plugin.rb'
          @plugins << File.basename(entry, '.*')
        elsif File.directory?(entry_path) && ['.', '..'].include?(File.basename(entry)) == false
          @subcategories << Category.new(entry_path, "#{@category_path}#{entry}/")
        end
      end
    end

    def name
      return @identifier.humanize
    end

  end

  class Validator

    attr_accessor :regex, :message

    def initialize(options)
      @regex = options[:regex]
      @message = options[:message]
    end

    def payload
      return {
        regex: @regex,
        message: @message[I18n.locale]
      }
    end

  end

  class Field

    attr_accessor :type, :id, :name, :description, :default_value, :optional, :validators

    def initialize(options)
      # Validate input
      [:type, :id, :name].each { |option| raise "#{option.to_s} must be set" if options[option].nil? }

      # Set properties
      @type = options[:type]
      @id = options[:id]
      @name = options[:name]
      @description = options[:description]
      @default_value = options[:default_value]
      @optional = options[:optional] || true
      @validators = options[:validators]
    end

    def self.string(options)
      options[:type] = 'string'
      return Field.new(options)
    end

    def self.text(options)
      options[:type] = 'text'
      return Field.new(options)
    end

    def self.integer(options)
      options[:type] = 'integer'
      return Field.new(options)
    end

    def self.double(options)
      options[:type] = 'double'
      return Field.new(options)
    end

    def self.boolean(options)
      options[:type] = 'boolean'
      return Field.new(options)
    end

    def payload
      return {
        id: @id,
        type: @type,
        name: @name,
        description: @description,
        default_value: @default_value,
        optional: @optional,
        validators: @validators && @validators.map { |v| v.payload }
      }
    end

  end

  class Plugin

    def initialize(options)
      options.each_pair do |key, value|
        instance_variable_set('@' + key.to_s, value)
      end
    end

    # Methods to be overriden

    def self.name
      raise 'name method should be overriden by your plugin subclass'
    end

    def self.description
      raise 'description method should be overriden by your plugin subclass'
    end

    def self.author
      raise 'author method should be overriden by your plugin subclass'
    end

    def self.fields
      raise 'fields method should be overriden by your plugin subclass'
    end

    # Internal methods

    def self.payload
      return {
        name: self.name,
        description: self.description,
        author: self.author,
        fields: self.fields.map { |f| f.payload() }
      }
    end

    def self.render_script(options)
      plugin = self.class.new(options)
      template_path = File.join(File.dirname(__FILE__), "#{File.basename(__FILE__)}.erb")
      return ERB.new(File.read(template_path)).result(plugin.binding)
    end

  end

end
