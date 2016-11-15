class SystemsController < ApplicationController
  before_action :get_system, only: [:edit, :update, :show]

  def index
    @systems = System.paginate(page: params[:page])
  end

  def new
    @system = System.new
  end

  def create
    @system = System.new(system_params)

    if @system.save
      redirect_to :back, flash: { success: "System with #{@system.name} is Created Successfully!" }
    else
      render 'new'
    end
  end

  def show
    @system_histories = @system.system_histories.order_desending.paginate(page: params[:system_histories_page])
    @issues = @system.issues.order_desending.paginate(page: params[:issues_page])
  end

  def update
    if @system.update_attributes(system_params)
      redirect_to :back, flash: { success: "System details successfully updated" }
    else
      render 'edit'
    end
  end

  private

  def get_system
    @system = System.find(params[:id])
  end

  def system_params
    params.require(:system).permit(:employee_id, :assembled_on, :discarded_at, :working, :note, item_ids: [])
  end
end
