# frozen_string_literal: true

module Sample
  class Caf
    def self.load
      program = ::Program.find_by name: "CARE"

      cafs = ["Nary", "Sokra", "Mealea", "Thavy", "Marady", "Nita"]
      cafs.each do |name|
        commune = ::Pumi::Commune.all.sample
        address = "ផ្ទះលេខ#{rand(1..100)} ផ្លូវលេខ#{rand(100..300)} #{commune.address_km}"

        program.cafs.create(
          name: name,
          commune_id: commune.id,
          district_id: commune.district_id,
          province_id: commune.province_id,
          address: address
        )
      end
    end
  end
end
