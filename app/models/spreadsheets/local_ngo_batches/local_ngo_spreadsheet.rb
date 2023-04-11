# frozen_string_literal: true

module Spreadsheets
  module LocalNgoBatches
    class LocalNgoSpreadsheet
      attr_reader :program, :row, :user

      def initialize(program, row)
        @program = program
        @row = row
      end

      def process
        OpenStruct.new(
          local_ngo.attributes.merge({
            target_provinces: valid_target_provinces? ? provinces.map(&:name_km).join(", ") : province_ids,
            address: commune.try(:address) || row["commune_id"],
            valid?: local_ngo.valid?,
            reason: local_ngo.errors.full_messages,
            local_ngo: local_ngo
          })
        )
      end

      private
        def local_ngo
          @local_ngo ||= program.local_ngos.new(
            name: row["name"],
            commune_id: commune.try(:id),
            district_id: commune.try(:district_id),
            province_id: commune.try(:province_id),
            target_province_ids: row["target_province_ids"],
            website_url: row["website"]
          )
        end

        def commune
          @commune ||= Pumi::Commune.find_by_id(row["commune_id"])
        end

        def valid_target_provinces?
          province_ids.length == provinces.length
        end

        def province_ids
          @province_ids ||= row["target_province_ids"].to_s.delete(" ").split(",")
        end

        def provinces
          @provinces ||= Pumi::Province.all.select { |p| province_ids.include?(p.id) }
        end
    end
  end
end
