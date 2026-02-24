# Seeds — some agricultural fields in central Ukraine (Poltava region), enjoy ! :)

factory = RGeo::Geographic.spherical_factory(srid: 4326)

FIELDS_DATA = [
  {
    name: "North Wheat Field",
    geojson: {
      "type" => "MultiPolygon",
      "coordinates" => [[
        [
          [ 33.1210, 49.8540 ],
          [ 33.1310, 49.8540 ],
          [ 33.1320, 49.8480 ],
          [ 33.1215, 49.8465 ],
          [ 33.1180, 49.8490 ],
          [ 33.1210, 49.8540 ]
        ]
      ]]
    }
  },
  {
    name: "South Sunflower Field",
    geojson: {
      "type" => "MultiPolygon",
      "coordinates" => [[
        [
          [ 33.1350, 49.8410 ],
          [ 33.1470, 49.8420 ],
          [ 33.1490, 49.8360 ],
          [ 33.1380, 49.8340 ],
          [ 33.1330, 49.8370 ],
          [ 33.1350, 49.8410 ]
        ]
      ]]
    }
  },
  {
    name: "East Corn Field",
    geojson: {
      "type" => "MultiPolygon",
      "coordinates" => [[
        [
          [ 33.1550, 49.8500 ],
          [ 33.1650, 49.8510 ],
          [ 33.1670, 49.8440 ],
          [ 33.1600, 49.8420 ],
          [ 33.1530, 49.8450 ],
          [ 33.1550, 49.8500 ]
        ]
      ]]
    }
  },
  {
    name: "West Rapeseed Field",
    geojson: {
      "type" => "MultiPolygon",
      "coordinates" => [[
        [
          [ 33.1050, 49.8460 ],
          [ 33.1150, 49.8470 ],
          [ 33.1160, 49.8400 ],
          [ 33.1080, 49.8380 ],
          [ 33.1020, 49.8410 ],
          [ 33.1050, 49.8460 ]
        ]
      ]]
    }
  },
  {
    name: "River Bend Soy Field",
    geojson: {
      "type" => "MultiPolygon",
      "coordinates" => [
        [
          [
            [ 33.1260, 49.8310 ],
            [ 33.1340, 49.8320 ],
            [ 33.1360, 49.8270 ],
            [ 33.1280, 49.8250 ],
            [ 33.1240, 49.8275 ],
            [ 33.1260, 49.8310 ]
          ]
        ],
        [
          [
            [ 33.1390, 49.8300 ],
            [ 33.1450, 49.8305 ],
            [ 33.1460, 49.8260 ],
            [ 33.1400, 49.8245 ],
            [ 33.1375, 49.8265 ],
            [ 33.1390, 49.8300 ]
          ]
        ]
      ]
    }
  }
].freeze

FIELDS_DATA.each do |data|
  shape = RGeo::GeoJSON.decode(data[:geojson].to_json, geo_factory: factory)

  field = Field.find_or_initialize_by(name: data[:name])
  field.shape = shape
  field.save!

  puts "Seeded: #{field.name} (#{field.area} ha)"
end
