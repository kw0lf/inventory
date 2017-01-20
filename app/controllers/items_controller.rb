class ItemsController < ApplicationController

  before_action :get_item, only: [:show, :edit, :update, :destroy, :discard, :allocate, :reallocate, :remove_item, :change_parent, :change_child, :addchild]

  def index
    @items = Item.includes(:brand, :category, :issues, :checkouts)
    @items = @items.not_erased.active
    @items = @items.where(category_id: params[:category]) if params[:category].present?
    @items = @items.where(brand_id: params[:brand]) if params[:brand].present?
    @items = @items.paginate(page: params[:page])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)

    if request.xhr?
      @item.save
    else
      if @item.save
        redirect_to :back, flash: { success: t('create') }
      else
        render 'new'
      end
    end
  end

  def update
    if request.xhr?
      @item.update_attributes(item_params)
    else
      if @item.update_attributes(item_params)
        redirect_to :back, flash: { success: t('update') }
      else
        render 'edit'
      end
    end
  end

  def discard
    @item.discard(discard_params["discard_reason"])
    redirect_to items_path, flash: { success: t('discard') }
  end

  def show
    @item_histories = @item.item_histories.order_desending.paginate(page: params[:item_histories_page])
    @checkouts      = @item.checkouts.order_desending.paginate(page: params[:checkouts_page])
    @issues         = @item.issues.includes(:system).order_desending.paginate(page: params[:issues_page])
    @subitem        = Item.filter_subitem(@item)
    @parent         = Item.find_by_id(@item.parent_id)
  end

  def reallocate
    @item.reallocate(reallocate_employee_params["employee_id"])
    redirect_to :back, flash: { success: t('reallocate') }
  end

  def destroy
    @item.update_attributes(parent_id: nil, working: false, deleted_at: Time.now, employee_id: nil)
    redirect_to items_path, flash: { success: t('destroy.success') }
  end

<<<<<<< HEAD
=======
  def discard
    @item.update_attributes(parent_id: nil, working: false, discarded_at: Time.now, employee_id: nil)
    redirect_to items_path, flash: { success: t('discard') }
  end

  def remove_item
    @item.update_attributes(parent_id: nil)
    redirect_to item_path
  end

  def change_parent
    if Item.find_by_id(parent_params["parent_id"]).present? && @item.id != parent_params["parent_id"].to_i
      @item.update_attributes(parent_id: parent_params["parent_id"])
      redirect_to item_path
    else
      flash[:alert] = t('change_parent')
      render :addparent
    end
  end

  def addparent
    @item = Item.find_by_id(params[:id])
  end

<<<<<<< HEAD
>>>>>>> Added a button on item show page to change parent id
=======
  def item_render
    if @item = Item.find_by_id(params[:id])
      @subitem = Item.filter_subitem(params[:id])
    end
  end

  def parent_render
    if @item = Item.find_by_id(params[:id])
      @parent = Item.find(@item.parent_id) if @item.parent_id.present?
    end
  end

  def change_child
   if Item.find_by_id(parent_params["parent_id"]).present?
    @update_child =Item.find(parent_params["parent_id"]).update_attributes(parent_id: params[:id])
    redirect_to item_path
   else
     flash[:alert] = t('change_child')
     render :addchild
   end
  end

>>>>>>> Add new item from show page
  private

  def get_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:model_number, :category_id, :brand_id, :serial_number, :purchase_on, :vendor_id, :working, :system_id, :employee_id, :parent_id,  :warranty_expires_on, :note, documents_attributes: [:title, :attachment])
  end

  def reallocate_employee_params
    params.require(:item).permit(:employee_id)
  end

<<<<<<< HEAD
   def discard_params
    params.require(:item).permit(:discard_reason)
=======
  def parent_params
    params.require(:item).permit(:parent_id)
>>>>>>> Added a button on item show page to change parent id
  end
end
