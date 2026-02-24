require "rails_helper"

RSpec.describe Field, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:shape) }
    it { is_expected.to validate_uniqueness_of(:name) }

    describe "shape overlap" do
      let(:factory) { RGeo::Geographic.spherical_factory(srid: 4326) }

      def make_shape(coordinates)
        geojson = { "type" => "MultiPolygon", "coordinates" => [ [ coordinates ] ] }.to_json
        RGeo::GeoJSON.decode(geojson, geo_factory: factory)
      end

      before do
        create(:field, name: "Existing Field", shape: make_shape([
          [ 30.0, 50.0 ], [ 30.1, 50.0 ], [ 30.1, 50.1 ], [ 30.0, 50.1 ], [ 30.0, 50.0 ]
        ]))
      end

      it "is invalid when the shape overlaps an existing field" do
        field = build(:field, name: "Overlapping Field", shape: make_shape([
          [ 30.05, 50.05 ], [ 30.15, 50.05 ], [ 30.15, 50.15 ], [ 30.05, 50.15 ], [ 30.05, 50.05 ]
        ]))
        expect(field).not_to be_valid
        expect(field.errors[:shape]).to include("overlaps with an existing field")
      end

      it "is valid when the shape does not overlap any existing field" do
        field = build(:field, name: "Clear Field", shape: make_shape([
          [ 31.0, 51.0 ], [ 31.1, 51.0 ], [ 31.1, 51.1 ], [ 31.0, 51.1 ], [ 31.0, 51.0 ]
        ]))
        expect(field).to be_valid
      end
    end
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
