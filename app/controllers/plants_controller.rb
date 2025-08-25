class PlantsController < ApplicationController
  before_action :set_plant, only: %i[show edit update destroy]

  # GET /plants
  def index
    @plants = current_user.plants
  end

  # GET /plants/1
  def show
  end

  # GET /plants/new
  def new
    @plant = current_user.plants.build
  end

  # GET /plants/1/edit
  def edit
  end

  # POST /plants
  def create
    @plant = current_user.plants.build(plant_params)
    if @plant.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @plant, notice: "Plant was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /plants/1
  def update
    if @plant.update(plant_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @plant, notice: "Plant was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /plants/1
  def destroy
    @plant.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to plants_url, notice: "Plant was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plant
      @plant = Plant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def plant_params
      params.require(:plant).permit(:name, :date_acquired)
    end
end
