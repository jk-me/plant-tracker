require "csv"

class PlantsController < ApplicationController
  before_action :set_plant, only: %i[show edit update destroy]
  helper_method :header_to_attr

  # GET /plants
  def index
    @plants = Current.user.plants
    @headers = header_map.keys
  end

  # GET /plants/1
  def show
  end

  # GET /plants/new
  def new
    @plant = Current.user.plants.build
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

    def header_map
      {
      "BS" => "blooming_size",
      "Name" => "name",
      "Since Update" => "",
      "Since Last Pic" => "",
      "Since Slow Release" => "",
      "Since Repot" => "",
      "Since Acquired" => "",
      "To-Do" => "todo",
      "Location" => "location",
      "Last Update" => "last_update_date",
      "Last Photo" => "last_photo_date",
      "Slow Release" => "slow_release_date",
      "Re-Potted" => "repotted_date",
      "Acquired Date" => "acquired_date",
      "Orchid Family" => "orchid_family",
      "Summer In/Out" => "summer_in_out",
      "Vendor" => "vendor",
      "Cost" => "cost",
      "Shipping Cost (Per Plant)" => "shipping_cost",
      "Total Cost" => "total_cost",
      "Mislabeled (Orig Tag)" => "mislabeled_original_tag",
      "Light" => "light",
      "Water" => "water",
      "Temperature" => "temperature",
      "Common Issues" => "common_issues",
      "Dormancy" => "dormancy",
      "Orchid Ancestry Link" => "orchid_ancestry_link",
      "Species Ancestry" => "species_ancestry"
      }
    end

  def header_to_attr(label)
    header_map[label]
  end
end
