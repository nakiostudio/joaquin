class CloneRepo < Plugin

  def name
    return 'Clone Git repository'
  end

  def description
    return 'Clones the given Git repository checking out the branch specified'
  end

  def author
    return 'Carlos Vidal'
  end

  def category
    return 'version_control'
  end

  def fields
    return [
      Field.string(
        id: 'repository_address',
        name: 'Repository address',
        description:
          'Address of the Git repository (http or ssh). Note: if this job is going'\
          'to be triggered by a webhook that provides repository url and branch then'\
          'filling this field is not required',
        default_value: nil,
        optional: true,
        validate: nil
      ),
      Field.string(
        id: 'branch',
        name: 'Branch',
        description:
          'Brand to checkout once the repository is cloned. Note: if this job is going'\
          'to be triggered by a webhook that provides repository url and branch then'\
          'filling this field is not required',
        default_value: nil,
        optional: true,
        validate: nil
      )
    ]
  end

end
