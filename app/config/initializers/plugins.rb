plugins_directory = Rails.root.join('plugins')
require File.join(plugins_directory, 'plugin')

Rails.application.config.root_category = Plugins::Category.new(plugins_directory)
