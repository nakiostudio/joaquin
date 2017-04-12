class NodesController < ApplicationController

  before_action :authenticate_user!

  def index
    @nodes = Node.all
  end

  def create

  end

end
