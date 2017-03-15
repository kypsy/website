class Admin::ActivitiesController < ApplicationController
  before_action :require_admin
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  # GET /admin/activities
  def index
    @activities = Activity.all
  end

  # GET /admin/activities/1
  def show
    redirect_to [:admin, :activities]
  end

  # GET /admin/activities/new
  def new
    @activity = Activity.new
  end

  # GET /admin/activities/1/edit
  def edit
  end

  # POST /admin/activities
  def create
    @activity = Activity.new(activity_params)

    if @activity.save
      redirect_to [:admin, @activity], notice: "Activity was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /admin/activities/1
  def update
    if @activity.update(activity_params)
      redirect_to [:admin, @activity], notice: "Activity was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /admin/activities/1
  def destroy
    @activity.destroy
    redirect_to [:admin, :activities], notice: "Activity was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_activity
    @activity = Activity.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def activity_params
    params.require(:activity).permit(:name)
  end
end
