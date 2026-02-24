FactoryBot.define do
  factory :field do
    name { "Test Field" }
    shape do
      geojson = {
        "type" => "MultiPolygon",
        "coordinates" => [ [ [ [ 30.0, 50.0 ], [ 30.1, 50.0 ], [ 30.1, 50.1 ], [ 30.0, 50.1 ], [ 30.0, 50.0 ] ] ] ]
      }.to_json
      RGeo::GeoJSON.decode(geojson, geo_factory: RGeo::Geographic.spherical_factory(srid: 4326))
    end
    area { 0.0 }
  end
end
