class StudySetsController < ApplicationController
  before_action :set_study_set, only: [:show, :edit, :update, :destroy, :select_courses, :add_course, :remove_course, :study]

  def index
    @study_sets = current_user.study_sets.includes(:courses, :learning_plan)
  end

  def show
    @courses = @study_set.courses.includes(:course_items)
    @progress = @study_set.progress_percentage
  end

  def new
    @study_set = current_user.study_sets.new
  end

  def create
    @study_set = current_user.study_sets.new(study_set_params)

    if @study_set.save
      redirect_to select_courses_study_set_path(@study_set), notice: 'Study set was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @study_set.update(study_set_params)
      redirect_to @study_set, notice: 'Study set was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @study_set.destroy
    redirect_to study_sets_path, notice: 'Study set was successfully deleted.'
  end

  def select_courses
    @available_courses = Course.joins(:learning_resource)
                              .includes(:learning_resource)
                              .where.not(id: @study_set.course_ids)
  end

  def add_course
    course = Course.find(params[:course_id])
    @study_set.courses << course
    redirect_to @study_set, notice: 'Course was successfully added to the study set.'
  end

  def remove_course
    course = Course.find(params[:course_id])
    @study_set.courses.delete(course)
    redirect_to @study_set, notice: 'Course was successfully removed from the study set.'
  end

  def study
    @items = @study_set.next_items_to_study
    Rails.logger.debug "Study Set ID: #{@study_set.id}"
    Rails.logger.debug "Course IDs: #{@study_set.course_ids.inspect}"
    Rails.logger.debug "Total course items: #{@study_set.courses.joins(:course_items).count}"
    Rails.logger.debug "Total study progress records: #{@study_set.study_progress_records.count}"
    Rails.logger.debug "Items to study count: #{@items.size}"
    Rails.logger.debug "Review times: #{@study_set.study_progress_records.pluck(:next_review_at, :updated_at).inspect}"
    Rails.logger.debug "Current time: #{Time.current}"
    
    @progress = @study_set.study_progress_records.find_by(course_item: @items.first) if @items.any?
  end

  private

  def set_study_set
    @study_set = current_user.study_sets.find(params[:id])
  end

  def study_set_params
    params.require(:study_set).permit(:title, :description)
  end
end
