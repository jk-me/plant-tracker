require "csv"

class PlantsController < ApplicationController
  before_action :set_plant, only: %i[show edit update destroy]
  helper_method :header_to_attr

  # GET /plants
  def index
    @plants = Current.user.plants
    # Prefer the CSV file in the repository's orchid_data directory
    csv_filename = "Orchid tracker cd752fe52ffe4bb0b903923cdc453a4c_all copy.csv"
    csv_path = Rails.root.join("orchid_data", csv_filename)

    if File.exist?(csv_path)
      begin
        parsed = CSV.read(csv_path)
      rescue => e
        # If reading fails for any reason, fall back to the embedded sample below
        Rails.logger.warn("Failed to read CSV at #{csv_path}: #{e.message}")
        parsed = nil
      end
    end
    @headers = parsed[0] || []
    @sample_rows = parsed[1..] || []
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

  # Convert header label into a model attribute name using an explicit map
  # Falls back to a conservative snake_case conversion when a label isn't present in the map.
  def header_to_attr(label)
    return "" if label.nil?

    key = label.to_s.strip.downcase

    map = {
      "bs" => "blooming_size",
      "name" => "name",
      "since update" => "since_update",
      "since last pic" => "since_last_pic",
      "since slow release" => "since_slow_release",
      "since repot" => "since_repot",
      "to-do" => "todo",
      "todo" => "todo",
      "location" => "location",
      "last update" => "last_update_date",
      "last photo" => "last_photo_date",
      "slow release" => "slow_release_date",
      "re-potted" => "repotted_date",
      "re potted" => "repotted_date",
      "orchid family" => "orchid_family",
      "since acquired" => "since_acquired",
      "summer in/out" => "summer_in_out",
      "summer in_out" => "summer_in_out",
      "vendor" => "vendor",
      "cost" => "cost",
      "shipping cost (per plant)" => "shipping_cost_per_plant",
      "shipping cost per plant" => "shipping_cost_per_plant",
      "total cost" => "total_cost",
      "acquired date" => "acquired_date",
      "mislabeled (orig tag)" => "mislabeled_original_tag",
      "mislabeled" => "mislabeled_original_tag",
      "light" => "light",
      "water" => "water",
      "temperature" => "temperature",
      "common issues" => "common_issues",
      "dormancy" => "dormancy",
      "orchid ancestry link" => "orchid_ancestry_link",
      "species ancestry" => "species_ancestry"
    }

    mapped = map[key]
    return mapped if mapped.present?

    # Fallback: conservative snake_case conversion
    label.to_s.downcase.gsub(/[^a-z0-9]+/, "_").gsub(/^_|_$/, "")
  end
end
