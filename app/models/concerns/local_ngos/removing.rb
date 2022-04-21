module LocalNgos::Removing
  extend ActiveSupport::Concern

  included do
    def remove!
      return if locked?
      return self.destroy if scorecards.with_deleted.present?

      self.really_destroy!
    end

    def locked?
      scorecards.present?
    end
  end
end
