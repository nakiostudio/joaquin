class JobType < ActiveRecord::Base

  has_many :step_types

  def payload
    return {
      id: self.id,
      slug: self.slug,
      name: self.name,
      step_types: self.step_types.map { |s| s.payload() }
    }
  end

end
