# frozen_string_literal: true

module IndicatorActionsHelper
  def indicator_action_filter_url(kind='')
    indicator_indicator_actions_path(@indicator, kind: kind, name: params[:name])
  end
end
