class JobTypesController < ApplicationController

  before_action :authenticate_user!, :fetch_summary_items

  def index
    @job_types = []
  end

  def new
    @job_type = JobType.new
    @target_action = 'create'
    @categories = Rails.application.config.root_category.subcategories
    @plugins = Rails.application.config.root_category.plugins
  end

end
