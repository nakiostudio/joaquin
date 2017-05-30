class JobTypesController < ApplicationController

  before_action :authenticate_user!, :fetch_summary_items

  def index
    @job_types = []
  end

  def new
    @job_type = JobType.new
  end

  def create
    name = params[:name]
    job_type = JobType.new({name: name, slug: name.dup.parameterize})

    unless job_type.save
      render status: 400, json: {}
      return
    end

    render status: 201, json: job_type_params(job_type)
  end

  def update
    job_type = JobType.find(params[:id])

    if job_type.nil?
      render status: 404, json: {}
      return
    end

    params[:slug] = params[:name].dup.parameterize
    job_type.update_attributes(job_type_params)

    unless job_type.save
      render status: 400, json: {}
    end

    render status: 200, json: job_type.payload()
  end

  def show
    @job_type = JobType.find(params[:id])

    if request.content_type =~ /json/
      render status: 404, json: {} if @job_type.nil?
      render status: 200, json: @job_type.payload()
      return
    end

    render 'new'
  end

  private

  def job_type_params
    return params.require(:job_type).permit(:name, :slug)
  end

end
