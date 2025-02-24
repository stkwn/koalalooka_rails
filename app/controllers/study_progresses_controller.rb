class StudyProgressesController < ApplicationController
  before_action :set_study_progress, only: [:update, :mark_as_studied]
  before_action :authorize_progress!, only: [:update, :mark_as_studied]

  def update
    if @study_progress.update(study_progress_params)
      redirect_to study_study_set_path(@study_progress.study_set), notice: 'Progress was successfully updated.'
    else
      redirect_to study_study_set_path(@study_progress.study_set), alert: 'Failed to update progress.'
    end
  end

  def mark_as_studied
    confidence_level = params[:confidence_level].to_i

    @study_progress.mark_as_studied!(confidence_level)
    
    respond_to do |format|
      format.html { redirect_to study_study_set_path(@study_progress.study_set) }
      format.json { render json: { status: :success, message: 'Progress updated' } }
    end
  end

  private

  def set_study_progress
    @study_progress = StudyProgress.find(params[:id])
  end

  def study_progress_params
    params.require(:study_progress).permit(:status, :confidence_level)
  end

  def authorize_progress!
    unless @study_progress.user == current_user
      respond_to do |format|
        format.html { 
          redirect_to study_sets_path, 
          alert: 'You are not authorized to update this progress.' 
        }
        format.json { 
          render json: { error: 'Unauthorized' }, 
          status: :unauthorized 
        }
      end
    end
  end
end
