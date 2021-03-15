# frozen_string_literal: true

module Sample
  class Caf
    def self.load
      cafs = ["Nary", "Sokra", "Mealea", "Thavy", "Marady", "Nita", "Orenida"]
      cafs.each do |name|
        local_ngo = ::LocalNgo.all.sample
        commune = ::Pumi::Commune.all.sample
        address = "ផ្ទះលេខ#{rand(1..100)} ផ្លូវលេខ#{rand(100..300)} #{commune.address_km}"

        local_ngo.cafs.create(
          name: name,
          sex: %w(female male other).sample,
          date_of_birth: rand(20..50).years.ago,
          tel: "",
          address: address
        )
      end
    end
  end
end
