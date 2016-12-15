class SystemsController < ApplicationController
  before_action :get_system, only: [:edit, :update]

  def index
    @systems = System.paginate(page: params[:page])
  end

  def new
    @system = System.new
  end

  def create
    @system = System.new(system_params)

    if request.xhr?
      @system.save
    else
      if @system.save
        redirect_to :back, flash: { success: t('create') }
      else
        render 'new'
      end
    end
  end

  def show
    @system           = System.includes(items: [:brand, :category]).find(params[:id])
    @system_histories = @system.system_histories.order_desending.paginate(page: params[:system_histories_page])
    @issues           = @system.issues.includes(item: [:brand, :category]).order_desending.paginate(page: params[:issues_page])
  end

  def update
    if request.xhr?
      @system.update_attributes(system_params)
    else
      if @system.update_attributes(system_params)
        redirect_to :back, flash: { success: t('update') }
      else
        render 'edit'
      end
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
