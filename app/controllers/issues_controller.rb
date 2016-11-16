class IssuesController < ApplicationController
  before_action :get_issue, only: [:edit, :update, :show, :destroy]

  def index
    @issues = Issue.includes(:system, item: [:brand, :category]).paginate(page: params[:page])
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new(issue_params)

    if @issue.save
      redirect_to :back, flash: { success: "Issue has been Created Successfully!" }
    else
      render 'new'
    end
  end

  def update
    if @issue.update(issue_params)
      redirect_to :back, flash: { success: "Issue was successfully updated" }
    else
      render 'edit'
    end
  end

  def destroy
    if @issue.destroy
      flash[:success] = "Issue was successfully deleted"
      redirect_to issues_path
    else
      flash[:danger] = "Sorry!! not able to delete"
      redirect_to issues_path
    end
  end

  private

  def get_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:item_id, :system_id, :title, :description, :closed_at, :note)
  end
end
