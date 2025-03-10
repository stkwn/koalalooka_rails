# app/controllers/course_items_controller.rb
class CourseItemsController < ApplicationController
  before_action :set_course
  before_action :set_course_item, only: [:show, :edit, :update, :destroy]

  # 获取某个课程的所有项目
  def index
    @course_items = @course.course_items.order(:created_at)
  end

  # 查看单个课程项目
  def show
  end

  # 新建课程项目页面
  def new
    @course_item = @course.course_items.new
  end

  # 创建课程项目
  def create
    @course_item = @course.course_items.new(course_item_params)
    
    respond_to do |format|
      if @course_item.save
        format.html { redirect_to course_course_item_path(@course, @course_item), notice: '课程项目创建成功！' }
        format.json { render json: { status: :success, message: '课程项目创建成功！' }, status: :created }
      else
        format.html { render :new }
        format.json { render json: { status: :error, message: @course_item.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      end
    end
  end

  # 编辑课程项目页面
  def edit
  end

  # 更新课程项目
  def update
    respond_to do |format|
      if @course_item.update(course_item_params)
        format.html { redirect_to course_path(@course), notice: '课程项目更新成功！' }
        format.json { render json: { status: :success, message: '课程项目更新成功！' }, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: { status: :error, message: @course_item.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      end
    end
  end

  # 删除课程项目
  def destroy
    @course_item.destroy
    respond_to do |format|
      format.html { redirect_to course_path(@course), notice: '课程项目已删除。' }
      format.json { render json: { status: :success, message: '课程项目已删除。' }, status: :ok }
    end
  end

  private

  # 设置当前课程
  def set_course
    @course = Course.find(params[:course_id])
  end

  # 设置当前课程项目
  def set_course_item
    @course_item = @course.course_items.find(params[:id])
  end

  # 允许的参数
  def course_item_params
    params.require(:course_item).permit(:term, content: {})
  end
end
