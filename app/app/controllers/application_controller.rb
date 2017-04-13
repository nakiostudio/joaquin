class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def fetch_summary_items
    @active_nodes = Node.where(status: 'online')
    @jobs = []
  end

end
