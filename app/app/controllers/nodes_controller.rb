class NodesController < ApplicationController

  before_action :authenticate_user!, :fetch_summary_items

  def index
    @nodes = Node.all
    @active_nodes = []
  end

  def create

  end

end
