# frozen_string_literal: true

module Sample
  class Scorecard
    def self.load
      21.times do |i|
        build_scorecard(uuid)
      end
    end

    private
      def self.build_scorecard
        number_of_caf = rand(1..5)
        number_of_participant = rand(5..15)
        number_of_female = rand(1...number_of_participant)
        caf_members = (1..number_of_caf).to_a.map { |i| "Caf #{i}" }
        conducted_date = Date.today
        # conducted_year = conducted_date.year
        sector = ["Primary School", "Health Center", "Commune"].sample
        commune = ::Pumi::Commune.all.sample
        category = ::Scorecard.categories.keys.sample

        ::Scorecard.create({
          conducted_date: conducted_date,
          # conducted_year: conducted_year,
          province_id: commune.province_id,
          district_id: commune.district_id,
          commune_id: commune.id,
          category: category,
          sector: sector,
          number_of_caf: number_of_caf,
          number_of_participant: number_of_participant,
          number_of_female: number_of_female,
          caf_members: caf_members,
        })
      end
  end
end
