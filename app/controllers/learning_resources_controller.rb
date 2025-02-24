class LearningResourcesController < ApplicationController

  before_action :resource, only: [:show, :edit, :update, :destroy]

  def index
    @learning_resources = LearningResource.all
  end

  def show
  end

  def new
    @learning_resource = LearningResource.new
  end

  def create
    @learning_resource = LearningResource.new(learning_resource_params)
    if @learning_resource.save
      redirect_to @learning_resource, notice: "Learning resource was successfully created!"
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @learning_resource.update(learning_resource_params)
      redirect_to @learning_resource, notice: "Learning resource was successfully updated!"
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @learning_resource.destroy
    redirect_to learning_resources_path, notice: "Learning resource was successfully deleted!"
  end

  private

  def resource 
    @learning_resource = LearningResource.find(params[:id])
  end

  def learning_resource_params
    params.require(:learning_resource).permit(:title, :description, :publisher, :image_url)
  end

end
