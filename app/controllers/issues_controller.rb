# frozen_string_literal: true

class IssuesController < ApplicationController
  def index
    @scorecard = Scorecard.find(params[:scorecard_id])
  end
end
