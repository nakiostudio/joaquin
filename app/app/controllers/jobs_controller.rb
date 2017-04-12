class JobsController < ApplicationController

  before_action :authenticate_user!, :fetch_summary_items

  def index
    @active_nodes = []
  end

end
