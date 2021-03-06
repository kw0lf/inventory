class EmployeesController < ApplicationController
  before_action :get_employee, only: [:edit, :update, :show, :destroy, :allocate_item, :add_item]

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)

    if request.xhr?
      @employee.save
    else
      if @employee.save
        redirect_to :back, flash: { success: t('create') }
      else
        render 'new'
      end
    end
  end

  def update
    if request.xhr?
      @employee.update_attributes(employee_params)
    else
      if @employee.update_attributes(employee_params)
        redirect_to :back, flash: { success: t('update') }
      else
        render 'edit'
      end
    end
  end

  def index
    @employees = Employee.order_by_name.paginate(page: params[:page])
  end

  def show
    @items = @employee.items.includes(:brand, :category).order_desending.paginate(page: params[:items_page])
  end

  def add_item
    if item = Item.find_by_id(params[:item])
      item.update_attributes(employee_id: @employee.id)
    end

    redirect_to employee_path
  end

  def destroy
    @employee.update_attributes(active: false)

    if @employee.destroy
      redirect_to employees_path, flash: { success: t('destroy.success') }
    end
  end

  def fetch
    FetchExternalEmployee.add_employees()
    redirect_to employees_path
  end

  private

  def get_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:name, :email, :active, :id)
  end
end
