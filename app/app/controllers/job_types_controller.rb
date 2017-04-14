class JobTypesController < ApplicationController

  before_action :authenticate_user!, :fetch_summary_items

  def index
    @job_types = []
  end

end
