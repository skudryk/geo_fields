class FieldOverlapChecker
  attr_reader :field

  def initialize(field)
    @field = field
  end

  # ST_Intersects covers next types of intrssection: overlap, containment, and crossing.
  def overlapping_fields
    return Field.none unless field.shape

    ewkt = "SRID=#{field.shape.srid};#{field.shape.as_text}"

    scope = Field.where(
      "ST_Intersects(shape::geometry, ST_GeomFromEWKT(:ewkt)::geometry)",
      ewkt: ewkt
    )
    scope = scope.where.not(id: field.id) if field.persisted?
    scope
  end

  def overlaps?
    overlapping_fields.exists?
  end
end
