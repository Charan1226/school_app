class CoursesController < ApplicationController
  before_action :set_school, except: %i[ apply_batches ]
  before_action :set_course, only: %i[ show edit update destroy apply_batches ]
  before_action :authorize_action, only: %i[ new create edit update destroy ]
  before_action :authorize_student, only: %i[ apply_batches ]

  # GET /courses or /courses.json
  def index
    @courses = @school.courses
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = @school.courses.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
    @course = @school.courses.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(id: @course.id, school_id: @course.school_id), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(id: @course.id, school_id: @course.school_id), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url(school_id: @course.school_id), notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def apply_batches
    if params[:course].present?
      batch_ids = [params[:course][:batch_ids]].flatten
      @student = current_user
      @student.request_batch_id = @student.request_batch_id + batch_ids

      if @student.save
        redirect_to course_path(id: @course.id, school_id: @course.school_id), notice: 'Applied to batch.'
      else
        redirect_to :back
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    def set_school
      @school = School.find(params[:school_id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :school_id)
    end

    def authorize_action
      redirect_to :back, alert: 'You are not authorized to perform this action.' unless (current_user.admin? || @school.school_admin?(current_user))
    end

    def authorize_student
      redirect_to :back, alert: 'You are not authorized to perform this action.' unless current_user.student?
    end
end
