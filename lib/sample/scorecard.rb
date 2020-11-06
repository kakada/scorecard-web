# frozen_string_literal: true

module Sample
  class Scorecard
    def self.load
      1.times do |i|
        build_scorecard
      end
    end

    private
      def self.build_scorecard
        number_of_caf = rand(1..5)
        number_of_participant = rand(10..15)
        number_of_female = rand(1...number_of_participant)
        conducted_date = Date.today
        commune = ::Pumi::Commune.all.sample
        facility = ::Facility.where.not(parent_id: nil).sample
        local_ngo = ::LocalNgo.all.sample

        ::Scorecard.create({
          conducted_date: conducted_date,
          year: conducted_date.year,
          province_id: commune.province_id,
          district_id: commune.district_id,
          commune_id: commune.id,
          facility_id: facility.id,
          unit_type_id: facility.parent_id,
          number_of_caf: number_of_caf,
          number_of_participant: number_of_participant,
          number_of_female: number_of_female,
          local_ngo_id: local_ngo.id,
          program_id: local_ngo.program_id,
          scorecard_type: ::Scorecard::SCORECARD_TYPES.sample.last
        })
      end
  end
end
