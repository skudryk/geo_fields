require "rails_helper"

RSpec.describe Field, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:shape) }
  end

  describe "#shape_geo_json" do
    it "returns a GeoJSON string when shape is present" do
      field = build(:field)
      expect(field.shape_geo_json).to include("MultiPolygon")
    end

    it "returns nil when shape is nil" do
      field = build(:field, shape: nil)
      expect(field.shape_geo_json).to be_nil
    end
  end

  describe "callbacks" do
    it "registers calculate_area as a before_save callback" do
      filters = Field.__callbacks[:save].select { |cb| cb.kind == :before }.map(&:filter)
      expect(filters).to include(:calculate_area)
    end
  end
end
