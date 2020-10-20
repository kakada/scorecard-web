class ScorecardSerializer < ActiveModel::Serializer
  attributes :uuid, :unit_type_name, :category_name, :scorecard_type_name,
             :name, :description, :location, :address, :lat, :lng,
             :conducted_date, :number_of_caf, :number_of_participant, :number_of_female,
             :planned_start_date, :planned_end_date, :status, :program_id, :local_ngo_id,
             :scorecard_type_id, :local_ngo_name

  def unit_type_name
    object.unit_type.name
  end

  def category_name
    object.category.name
  end

  def scorecard_type_name
    object.scorecard_type.name
  end

  def local_ngo_name
    object.local_ngo.name
  end
end
