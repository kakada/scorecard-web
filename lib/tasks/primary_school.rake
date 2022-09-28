# frozen_string_literal: true

namespace :primary_school do
  desc "migrate target provinces"
  task migrate_location: :environment do
    PrimarySchool.find_each do |school|
      commune = Pumi::Commune.find_by_id(school.commune_id)
      school.update(district_id: commune.district_id, province_id: commune.province_id)
    end
  end

  desc "migrate school to dataset"
  task migrate_to_become_dataset: :environment do
    PrimarySchool.all.each do |ps|
      dataset = category.datasets.find_by(code: ps.code)
      next if dataset.present?

      category.datasets.create(ps.attributes.extract!("code", "name_en", "name_km", "commune_id", "district_id", "province_id"))
    end
  end

  private
    def category
      @category ||= get_category
    end

    def get_category
      cate = Category.find_by(code: "D_PS")
      return cate if cate.present?

      Category.create(
        code: "D_PS",
        name_en: "Primary school",
        name_km: "បឋមសិក្សា",
        hierarchy: ["province", "district", "commune"]
      )
    end
end
