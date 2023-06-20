class SchoolsController < ApplicationController
  before_action :set_school, only: %i[ show edit update destroy add_school_admins ]
  before_action :authorize_action, only: %i[ new create destroy add_school_admins ]
  before_action :authorize_admin, only: %i[ edit update ]


  # GET /schools or /schools.json
  def index
    @schools = School.all
  end

  # GET /schools/1 or /schools/1.json
  def show
  end

  # GET /schools/new
  def new
    @school = School.new
  end

  # GET /schools/1/edit
  def edit
  end

  # POST /schools or /schools.json
  def create
    @school = School.new(school_params)

    respond_to do |format|
      if @school.save
        format.html { redirect_to school_url(@school), notice: "School was successfully created." }
        format.json { render :show, status: :created, location: @school }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schools/1 or /schools/1.json
  def update
    respond_to do |format|
      if @school.update(school_params)
        format.html { redirect_to school_url(@school), notice: "School was successfully updated." }
        format.json { render :show, status: :ok, location: @school }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @school.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schools/1 or /schools/1.json
  def destroy
    @school.destroy

    respond_to do |format|
      format.html { redirect_to schools_url, notice: "School was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_school_admins
    if params[:school].present?
      admin_ids = params[:school][:user_ids]
      school_admins = User.where(id: admin_ids, role: 'school_admin')

      @school.school_admins << school_admins
      redirect_to school_path(@school), notice: 'School Admins successfully added.'
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_school
      @school = School.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def school_params
      params.require(:school).permit(:name)
    end

    def authorize_action
      redirect_to :back, alert: 'You are not authorized to perform this action.' unless (current_user.admin?)
    end

    def authorize_admin
      redirect_to :back, alert: 'You are not authorized to perform this action.' unless (current_user.admin? || @school.school_admin?(current_user))
    end
end
