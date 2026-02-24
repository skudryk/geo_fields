class Field < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :shape, presence: true
  validate :shape_does_not_overlap_existing_fields

  before_save :calculate_area

  def as_json(_options = {})
    {
      id:    id,
      name:  name,
      area:  area,
      shape: shape ? JSON.parse(shape_geo_json) : nil
    }
  end

  def shape_geo_json
    return nil unless shape

    RGeo::GeoJSON.encode(shape).to_json
  end

  private

  def shape_does_not_overlap_existing_fields
    return unless shape

    if FieldOverlapChecker.new(self).overlaps?
      errors.add(:shape, "overlaps with an existing field")
    end
  end

  def calculate_area
    return unless shape

    # NOTE: RGeo geographic (spherical) types don't expose `as_ewkt`;
    # so we have to construct EWKT manually from srid + WKT.
    ewkt   = "SRID=#{shape.srid};#{shape.as_text}"
    sql    = "SELECT ST_Area(ST_GeomFromEWKT($1)::geography) AS area"
    result = self.class.connection.exec_query(sql, "SQL", [ ewkt ]).first
    self.area = (result["area"].to_f / 10_000).round(4)
  end
end
