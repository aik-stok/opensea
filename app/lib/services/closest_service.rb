class ClosestService
  ActiveRecord::Base.connection.execute <<-SQL
    CREATE OR REPLACE FUNCTION haversine(alat double precision, alng double precision, blat double precision, blng double precision)
    RETURNS double precision AS
    $$
    SELECT asin(
      sqrt(
        sin(radians($3-$1)/2)^2 +
        sin(radians($4-$2)/2)^2 *
        cos(radians($1)) *
        cos(radians($3))
      )
    ) * 12742 AS distance;
    $$
    LANGUAGE 'sql' IMMUTABLE;
  SQL

  SHIPPABLE_TYPES = %w[Ship Shipment].freeze
  INNACCURACY = 0.1
  DAYS_INTERVAL = 7

  def initialize(id)
    @position = Position.eager_load(:port).find id
    @port = @position.port
    @opposite_type = SHIPPABLE_TYPES.find { |t| t != @position.shippable_type }
    @opposite_table = @opposite_type.pluralize.downcase
    @opposite_klass = @opposite_type.constantize
  end

  def find
    result = find_by_sql
    result = find_by_sql(days: DAYS_INTERVAL) if result.empty?
    result
  end

  private

  def find_by_sql(days: 0)
    subquery = select_by_haversine + join_tables + where_for_opened(DAYS_INTERVAL) + where_for_capacity
    Position.find_by_sql ["SELECT * FROM (#{subquery}) AS dt WHERE dt.distance = dt.min_distance", data_for_sql]
  end

  def select_by_haversine
    <<-SQL
      SELECT *,
        positions.id AS id,
        haversine(:lat, :lng, ports.lat, ports.lng) AS distance,
        MIN(haversine(:lat, :lng, ports.lat, ports.lng)) OVER () as min_distance
        FROM positions
    SQL
  end

  def join_tables
    <<-SQL
      INNER JOIN ports ON ports.id = positions.port_id
      INNER JOIN #{@opposite_table} ON #{@opposite_table}.id = shippable_id AND shippable_type = '#{@opposite_type}'
    SQL
  end

  def where_for_opened(days = 0)
    " WHERE opened_at BETWEEN :opened_at AND (date :opened_at + integer '#{days}')"
  end

  def where_for_capacity
    max = @position.shippable.hold_capacity * (1 + INNACCURACY)
    min = @position.shippable.hold_capacity * (1 - INNACCURACY)
    " AND #{@opposite_table}.hold_capacity BETWEEN #{min} AND #{max}"
  end

  def data_for_sql
    { lat: @port.lat, lng: @port.lng, opened_at: @position.opened_at }
  end
end
