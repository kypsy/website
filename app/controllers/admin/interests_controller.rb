class Admin::InterestsController < ApplicationController
  before_action :require_admin
  before_action :set_interest, only: [:show, :edit, :update, :destroy]

  # GET /admin/interests
  def index
    @interests = Interest.all
  end

  # GET /admin/interests/1
  def show
    redirect_to [:admin, :interests]
  end

  # GET /admin/interests/new
  def new
    @interest = Interest.new
  end

  # GET /admin/interests/1/edit
  def edit
  end

  # POST /admin/interests
  def create
    @interest = Interest.new(interest_params)

    if @interest.save
      redirect_to [:admin, @interest], notice: "Interest was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /admin/interests/1
  def update
    if @interest.update(interest_params)
      redirect_to [:admin, @interest], notice: "Interest was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /admin/interests/1
  def destroy
    @interest.destroy
    redirect_to [:admin, :interests], notice: "Interest was successfully destroyed."
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_interest
    @interest = Interest.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def interest_params
    params.require(:interest).permit(:name)
  end
end
