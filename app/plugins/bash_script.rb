module Plugins
  class BashScript < Plugin

    def self.name
      return 'Run bash script'
    end

    def self.description
      return 'Runs a bash script'
    end

    def self.author
      return 'Carlos Vidal'
    end

    def self.fields
      return [
        Field.text(
          id: 'script',
          name: 'Bash script',
          description: 'Bash script to be run.',
          default_value: '#!/bin/bash',
          optional: false,
          validators: [
            Validator.new(
              regex: '^(?!\s*$).+',
              message: {
                en: 'The script cannot be empty'
              }
            )
          ]
        )
      ]
    end

  end
end
