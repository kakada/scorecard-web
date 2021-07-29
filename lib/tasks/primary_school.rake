# frozen_string_literal: true

namespace :primary_school do
  desc "migrate target provinces"
  task migrate_location: :environment do
    PrimarySchool.find_each do |school|
      commune = Pumi::Commune.find_by_id(school.commune_id)
      school.update(district_id: commune.district_id, province_id: commune.province_id)
    end
  end
end
