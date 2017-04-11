class Node < ActiveRecord::Base

  enum status: [ :unpaired, :offline, :online ]

end
