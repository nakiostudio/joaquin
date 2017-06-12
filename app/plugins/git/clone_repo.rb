module Plugins
  class CloneRepo < Plugin

    def self.name
      return 'Clone Git repository'
    end

    def self.description
      return 'Clones the given Git repository checking out the branch specified'
    end

    def self.author
      return 'Carlos Vidal'
    end

    def self.fields
      return [
        Field.string(
          id: 'repository_address',
          name: 'Repository address',
          description:
            'Address of the Git repository (http or ssh). Note: if this job is going '\
            'to be triggered by a webhook that provides repository url and branch then '\
            'filling this field is not required.',
          placeholder: 'git@github.com:my_account/my_repo.git',
          optional: true,
          validators: [
            Validator.new(
              regex: '^[^@]+@[^:]+:[^/]+/[^.]+\.git$',
              message: {
                en: 'Not valid git repository url'
              }
            )
          ]
        ),
        Field.string(
          id: 'branch',
          name: 'Branch',
          description:
            'Brand to checkout once the repository is cloned. Note: if this job is going '\
            'to be triggered by a webhook that provides repository url and branch then '\
            'filling this field is not required.',
          placeholder: 'master',
          optional: true
        )
      ]
    end

  end
end
