class JobType < ActiveRecord::Base

  has_many :step_types

end
