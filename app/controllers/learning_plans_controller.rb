class LearningPlansController < ApplicationController
  before_action :set_study_set
  before_action :set_learning_plan, only: [:edit, :update, :destroy]

  def new
    @learning_plan = @study_set.build_learning_plan
  end

  def create
    @learning_plan = @study_set.build_learning_plan(learning_plan_params)

    if @learning_plan.save
      redirect_to @study_set, notice: 'Learning plan was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @learning_plan.update(learning_plan_params)
      redirect_to @study_set, notice: 'Learning plan was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @learning_plan.destroy
    redirect_to @study_set, notice: 'Learning plan was successfully deleted.'
  end

  private

  def set_study_set
    @study_set = current_user.study_sets.find(params[:study_set_id])
  end

  def set_learning_plan
    @learning_plan = @study_set.learning_plan
  end

  def learning_plan_params
    params.require(:learning_plan).permit(:daily_goal, :review_interval, :start_date, :end_date, :active)
  end
end
