# frozen_string_literal: true

namespace :local_ngo do
  desc "migrate target provinces"
  task migrate_target_provinces: :environment do
    LocalNgo.find_each do |ngo|
      ngo.update(target_provinces: Pumi::Province.all.select { |p| ngo.target_province_ids.split(",").include?(p.id) }.sort_by { |x| x.id }.map(&:name_km).join(", ")) if ngo.target_province_ids.present?
    end
  end
end
