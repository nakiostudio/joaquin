class NodesController < ApplicationController

  before_action :authenticate_user!, :fetch_summary_items

  def index
    @nodes = Node.all
    @active_nodes = []
  end

  def create
    # Create and persist node instance
    node = Node.new(node_params)

    if node.save
      flash[:notice] = I18n.t('nodes.form.success_message', node_name: node.alias)
      redirect_to action: 'index'
    else
      flash[:error] = node.errors.full_messages.join('. ')
      redirect_to action: 'new', alias: node.alias
    end
  end

  def new
    @node = Node.new({ alias: params[:alias], token: generate_hash })
  end

  def show
    @node = Node.find(params[:id])
    render 'new'
  end

  private

  def node_params
    return params.require(:node).permit(:alias, :token)
  end

  def generate_hash
    chars = [('a'..'z'), ('A'..'Z'), ('<'..'@')].map(&:to_a).flatten
    return (0...32).map { chars[rand(chars.length)] }.join
  end

end
