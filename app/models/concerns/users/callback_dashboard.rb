# frozen_string_literal: true

module Users::CallbackDashboard
  extend ActiveSupport::Concern

  included do
    after_create :add_to_dashboard_async, if: -> { confirmed? && !skip_callback }
    after_update :add_to_dashboard_async, if: -> { (was_confirmed? || was_activated?) && !skip_callback }
    after_update :remove_from_dashboard_async, if: -> { was_deactivated? && !skip_callback }

    # For soft delete
    unless ARGV.include? "assets:precompile"
      after_restore :add_to_dashboard_async, if: -> { confirmed? && !skip_callback }
    end

    after_destroy :remove_from_dashboard_async, unless: :skip_callback

    def add_to_dashboard
      Dashboard.new(self.program).add_user(self)
    end

    def remove_from_dashboard
      Dashboard.new(self.program).remove_user(self)
    end

    private
      def add_to_dashboard_async
        UserWorker.perform_async(:add_to_dashboard, id) unless gf_user_id.present?
      end

      def remove_from_dashboard_async
        UserWorker.perform_async(:remove_from_dashboard, id) if gf_user_id.present?
      end

      def was_activated?
        saved_change_to_actived? && self.actived
      end

      def was_deactivated?
        saved_change_to_actived? && !self.actived
      end

      def was_confirmed?
        saved_change_to_confirmed_at? && confirmed?
      end
  end
end
