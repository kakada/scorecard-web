# frozen_string_literal: true

module Samples
  class LocalNgo
    def self.load
      program = ::Program.find_by name: "CARE"

      local_ngos = ["NGO1", "NGO2"]
      local_ngos.each do |name|
        village = ::Pumi::Village.all.sample

        program.local_ngos.create(
          name: name,
          village_id: village.id,
          commune_id: village.commune_id,
          district_id: village.district_id,
          province_id: village.province_id,
        )
      end
    end
  end
end
