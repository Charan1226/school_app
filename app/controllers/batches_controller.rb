class BatchesController < ApplicationController
  before_action :set_course, except: %i[ add_students ]
  before_action :set_school, except: %i[ add_students ]
  before_action :set_batch, only: %i[ show edit update destroy add_students ]
  before_action :authorize_action, only: %i[ new create edit update destroy add_students ]

  # GET /batches or /batches.json
  def index
    @batches = @course.batches
  end

  # GET /batches/1 or /batches/1.json
  def show
  end

  # GET /batches/new
  def new
    @batch = Batch.new(course_id: @course.id, school_id: @school.id)
  end

  # GET /batches/1/edit
  def edit
  end

  # POST /batches or /batches.json
  def create
    @batch = @course.batches.new(batch_params)

    respond_to do |format|
      if @batch.save
        format.html { redirect_to batch_path(id: @batch.id, course_id: @batch.course_id, school_id: @batch.school_id), notice: "Batch was successfully created." }
        format.json { render :show, status: :created, location: @batch }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /batches/1 or /batches/1.json
  def update
    respond_to do |format|
      if @batch.update(batch_params)
        format.html { redirect_to batch_path(id: @batch.id, course_id: @batch.course_id, school_id: @batch.school_id), notice: "Batch was successfully updated." }
        format.json { render :show, status: :ok, location: @batch }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @batch.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /batches/1 or /batches/1.json
  def destroy
    @batch.destroy

    respond_to do |format|
      format.html { redirect_to batches_url(course_id: @batch.course_id, school_id: @batch.school_id), notice: "Batch was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_students
    if params[:batch].present?
      student_ids = params[:batch][:user_ids]
      students = User.where(id: student_ids, role: 'student')

      @batch.students << students
      redirect_to batch_path(id: @batch.id, course_id: @batch.course_id, school_id: @batch.school_id), notice: 'Students successfully added.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = Batch.find(params[:id])
    end

    def set_course
      @course = Course.find(params[:course_id])
    end

    def set_school
      @school = School.find(params[:school_id])
    end

    # Only allow a list of trusted parameters through.
    def batch_params
      params.require(:batch).permit(:name, :school_id, :course_id)
    end

    def authorize_action
      redirect_to :back, alert: 'You are not authorized to perform this action.' unless (current_user.admin? || @school.school_admin?(current_user))
    end
end
