# frozen_string_literal: true

class PrimarySchoolsController < ApplicationController
  def index
    @pagy, @primary_schools = pagy(authorize PrimarySchool.filter(params).order("#{sort_column} #{sort_direction}"))
  end

  def show
    @primary_school = authorize PrimarySchool.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def new
    @primary_school = authorize PrimarySchool.new
  end

  def create
    @primary_school = authorize PrimarySchool.new(primary_school_params)

    if @primary_school.save
      redirect_to primary_schools_url
    else
      render :new
    end
  end

  def edit
    @primary_school = authorize PrimarySchool.find(params[:id])
  end

  def update
    @primary_school = authorize PrimarySchool.find(params[:id])

    if @primary_school.update(primary_school_params)
      redirect_to primary_schools_url
    else
      render :edit
    end
  end

  def destroy
    @primary_school = authorize PrimarySchool.find(params[:id])
    @primary_school.destroy

    redirect_to primary_schools_url
  end

  def import
    Spreadsheets::PrimarySchoolSpreadsheet.new.import(params[:file])

    redirect_to primary_schools_url
  end

  private
    def primary_school_params
      params.require(:primary_school).permit(:code, :name_en, :name_km,
        :commune_id, :district_id, :province_id
      )
    end
end
