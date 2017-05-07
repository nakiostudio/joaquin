class StepTypesController < ApplicationController

  def create
    if params[:job_type_id].nil?
      render status: 404, json: {}
      return
    end

    if params[:plugin_path].nil?
      render status: 400, json: {}
      return
    end

    job_type = JobType.find(params[:job_type_id])

    if job_type.nil?
      render status: 404, json: {}
      return
    end

    plugin_id = params[:plugin_path].split('/').last
    name = plugin_id.humanize
    slug = "#{name.dup.parameterize}-#{Time.now.to_i}"
    step_type = StepType.new({slug: slug, name: name, plugin_path: params[:plugin_path]})
    job_type.step_types << step_type
    unless step_type.save && job_type.save
      render status: 400, json: {}
      return
    end

    render status: 201, json: job_type.payload
  end

  def update

  end

  def destroy
    job_type = JobType.find(params[:job_type_id])
    step_type = StepType.find(params[:step_type_id])

    if job_type.nil? || step_type.nil?
      render status: 404, json: {}
      return
    end

    step_type.destroy

    unless job_type.save
      render status: 400, json: {}
      return
    end

    render status: 200, json: job_type.payload()
  end

end
