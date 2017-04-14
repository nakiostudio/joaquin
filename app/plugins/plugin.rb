require 'erb'

class Field

  attr_accessor :type, :id, :name, :description, :default_value, :optional, :validate

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
    @validate = options[:validate]
  end

  def self.string(options)
    options[:type] = 'string'
    return Field.new(args)
  end

  def self.text(options)
    options[:type] = 'text'
    return Field.new(args)
  end

  def self.integer(options)
    options[:type] = 'integer'
    return Field.new(args)
  end

  def self.double(options)
    options[:type] = 'double'
    return Field.new(args)
  end

  def self.boolean(options)
    options[:type] = 'boolean'
    return Field.new(args)
  end

end

class Plugin

  def initialize(options)
    options.each_pair do |key, value|
      instance_variable_set('@' + key.to_s, value)
    end
  end

  # Methods to be overriden

  def name
    raise 'name method should be overriden by your plugin subclass'
  end

  def description
    raise 'description method should be overriden by your plugin subclass'
  end

  def author
    raise 'author method should be overriden by your plugin subclass'
  end

  def category
    raise 'category method should be overriden by your plugin subclass'
  end

  def fields
    raise 'fields method should be overriden by your plugin subclass'
  end

  # Internal methods

  def self.render_script(options)
    plugin = self.class.new(options)
    template_path = File.join(File.dirname(__FILE__), "#{File.basename(__FILE__)}.erb")
    return ERB.new(File.read(template_path)).result(plugin.binding)
  end

end
