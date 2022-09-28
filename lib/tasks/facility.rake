# frozen_string_literal: true

namespace :facility do
  desc "migrate to have primary school category in each program"
  task migrate_to_have_primary_school_category: :environment do
    facilities = Facility.where(dataset: "ps")
    facilities.update_all(category_id: category.id) if category.present?
  end

  private
    def category
      @category ||= Category.find_by(code: "D_PS")
    end
end
