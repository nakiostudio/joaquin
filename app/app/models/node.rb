class Node < ActiveRecord::Base

  validates :alias, length: { minimum: 4 }

  enum status: [ :unpaired, :offline, :online ]

end
