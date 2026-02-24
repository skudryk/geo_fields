class FieldsController < ApplicationController
  before_action :set_field, only: %i[show edit update destroy]
  before_action :authenticate_api!, if: -> { request.format.json? }

  def index
    @fields = Field.all
    respond_to do |format|
      format.html
      format.json { render json: fields_json(@fields) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: field_json(@field) }
    end
  end

  def new
    @field = Field.new
  end

  def edit; end

  def create
    @field = Field.new(field_params)

    respond_to do |format|
      if @field.save
        format.html { redirect_to @field, notice: "Field created." }
        format.json { render json: field_json(@field), status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @field.errors }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @field.update(field_params)
        format.html { redirect_to @field, notice: "Field updated." }
        format.json { render json: field_json(@field) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @field.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @field.destroy
    respond_to do |format|
      format.html { redirect_to fields_path, notice: "Field deleted." }
      format.json { head :no_content }
    end
  end

  private

  def set_field
    @field = Field.find(params[:id])
  end

  def field_params
    attrs = params.require(:field).permit(:name, :shape_geo_json)
    if attrs[:shape_geo_json].present?
      geo_factory = RGeo::Geographic.spherical_factory(srid: 4326)
      attrs = attrs.to_h
      attrs[:shape] = RGeo::GeoJSON.decode(attrs.delete(:shape_geo_json), geo_factory: geo_factory)
    end
    attrs
  end

  def authenticate_api!
    client_id     = request.headers["X-Client-Id"]
    client_secret = request.headers["X-Client-Secret"]

    valid_id     = ENV.fetch("API_CLIENT_ID", "dev_client_id")
    valid_secret = ENV.fetch("API_CLIENT_SECRET", "dev_client_secret")

    return if client_id == valid_id && client_secret == valid_secret

    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def fields_json(fields)
    fields.map { |f| field_json(f) }
  end

  def field_json(field)
    {
      id:    field.id,
      name:  field.name,
      area:  field.area,
      shape: field.shape ? JSON.parse(field.shape_geo_json) : nil
    }
  end
end
