class Users::CategoriesController < ApplicationController
  before_action :get_category, only: [:update]

  add_breadcrumb I18n.t("projects.title"), :user_projects_path
  add_breadcrumb I18n.t("categories.title"), :user_project_categories_path

  def index
    @project = current_user.projects.find(params[:project_id])
    @categories = @project.categories.paginate(page: params[:page])
  end

  def new
    @category = Category.new
    add_breadcrumb I18n.t("new"), :user_project_categories_path
  end

  def create
    @category = current_user.projects.find(params[:project_id]).categories.new(category_params)

    if @category.valid?
      @category.save
      flash[:notice] = I18n.t("categories.created")
      redirect_to user_project_categories_path
    else
      flash[:alert] = @category.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
  end

  def update
    @category.attributes = category_params
    if @category.valid?
      @category.save
      flash[:notice] = I18n.t("categories.updated")
      redirect_to user_project_categories_path
    else
      flash[:alert] = @category.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    category = current_user.categories.find(params[:id])
    if category.destroy
      flash[:notice] = I18n.t("categories.deleted")
      redirect_to tasks_path      
    else
      flash[:alert] = category.errors.full_messages.to_sentence
      redirect_to user_project_categories_path
    end
  end

  private
  def category_params
    params.require(:category).permit(:name, :description)
  end

  def get_category
    @category ||= current_user.projects.find(params[:project_id]).categories.find(params[:id])
  end
end