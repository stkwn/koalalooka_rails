# app/controllers/courses_controller.rb
class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # 获取所有课程
  def index
    @courses = Course.all
  end

  # 查看单个课程
  def show
    @course_items = @course.course_items
  end

  # 新建课程页面
  def new
    @course = Course.new
  end

  # 创建课程
  def create
    @course = Course.new(course_params)
    if @course.save
      redirect_to @course, notice: '课程创建成功！'
    else
      render :new
    end
  end

  # 编辑课程页面
  def edit
  end

  # 更新课程
  def update
    if @course.update(course_params)
      redirect_to @course, notice: '课程更新成功！'
    else
      render :edit
    end
  end

  # 删除课程
  def destroy
    @course.destroy
    redirect_to courses_url, notice: '课程已删除。'
  end

  private

  # 设置当前课程
  def set_course
    @course = Course.find(params[:id])
  end

  # 允许的参数
  def course_params
    params.require(:course).permit(:title, :description, :type, :learning_resource_id, :user_id)
  end
end