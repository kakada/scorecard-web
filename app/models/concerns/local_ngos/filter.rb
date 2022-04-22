module LocalNgos::Filter
  extend ActiveSupport::Concern

  included do
    class << self
      def filter(params)
        scope = all
        scope = by_keyword(params[:keyword], scope) if params[:keyword].present?
        scope = scope.where(program_id: params[:program_id]) if params[:program_id].present?
        scope
      end

      private
        def by_keyword(keyword, scope)
          return scope unless keyword.present?

          province_ids = Pumi::Province.all.select { |p| p.name_km.downcase.include?(keyword.downcase) || p.name_en.downcase.include?(keyword.downcase) }.map(&:id)

          scope.where("LOWER(name) LIKE ? OR LOWER(target_provinces) LIKE ? OR province_id IN (?)", "%#{keyword.downcase}%", "%#{keyword.downcase}%", province_ids)
        end
    end
  end
end
