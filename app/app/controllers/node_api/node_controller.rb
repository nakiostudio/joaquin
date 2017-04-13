class NodeApi::NodeController < ApplicationController

  skip_before_filter  :verify_authenticity_token

  def register
    token = request.headers['X-Joaquin-Node-Token']
    puts request.headers
    nodes = Node.where(token: token )
    node = nodes.first unless nodes.empty?
    node.update_attributes(register_node_params) unless node.nil?
    if !node.nil? && node.save
      node.update_attributes({
        status: :online,
        last_active: Time.now
      })
      node.save
      render status: 201, json: {}
    else
      errors = node.errors.full_messages unless node.nil?
      render status: 404, json: { error_messages: errors }
    end
  end

  def register_node_params
    return params.require(:node).permit(:os, :arch, :system, :local_host, :ip_address, :port, :shell, :user, :home_dir)
  end

end
