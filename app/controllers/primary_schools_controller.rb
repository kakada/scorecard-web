# frozen_string_literal: true

class PrimarySchoolsController < ApplicationController
  def index
    @primary_schools = PrimarySchool.where(commune_id: params[:commune_id])

    render json: @primary_schools
  end
end
