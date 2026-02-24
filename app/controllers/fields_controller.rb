class FieldsController < ApplicationController
  respond_to :html, :json

  before_action :set_field, only: %i[show edit update destroy]
  before_action :authenticate_api!, if: -> { request.format.json? }

  def index
    @fields = Field.all
    respond_with @fields
  end

  def show
    respond_with @field
  end

  def new
    @field = Field.new
    respond_with @field
  end

  def edit
    respond_with @field
  end

  def create
    @field = Field.new(field_params)
    respond_with_notice(respond: @field.save)
  end

  def update
    respond_with_notice(respond: @field.update(field_params))
  end

  def destroy
    respond_with_notice(respond: @field.destroy)
  end

  private

  def respond_with_notice(respond: true)
    action_status = I18n.t("actions.params[:action]")
    flash[:notice] = "Field #{action_status}."
    respond_with @field if respond
  end

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
end
