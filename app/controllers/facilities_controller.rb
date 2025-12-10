# frozen_string_literal: true

class FacilitiesController < ApplicationController
  def index
    respond_to do |format|
      format.html {
        @pagy, @facilities = pagy(current_program.facilities.roots.reorder(sort_column + " " + sort_direction).includes(:children, :unit_scorecards, :scorecards))
      }

      format.json {
        render json: current_program.facilities.roots
      }
    end
  end

  def children
    @facility = Facility.find(params[:id])

    render json: @facility.children
  end

  def show
    @facility = authorize Facility.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def new
    @facility = authorize Facility.new
  end

  def create
    if params[:predefined_facility_codes].present?
      create_from_predefined
    else
      @facility = authorize current_program.facilities.new(facility_params)

      if @facility.save
        redirect_to facilities_url
      else
        render :new
      end
    end
  end

  def predefined_facilities
    existing_codes = current_program.facilities.where(default: true).pluck(:code)
    @predefined_facilities = PredefinedFacility.all.reject { |pf| existing_codes.include?(pf.code) }

    render json: @predefined_facilities.as_json(methods: [:root?])
  end

  def destroy
    @facility = authorize Facility.find(params[:id])
    @facility.destroy

    redirect_to facilities_url
  end

  private
    def facility_params
      params.require(:facility).permit(:name_en, :name_km, :code, :parent_id, :has_child, :dataset, :category_id)
    end

    def create_from_predefined
      codes = params[:predefined_facility_codes].reject(&:blank?)
      created_facilities = []

      ActiveRecord::Base.transaction do
        # Get all predefined facilities and sort by parent relationship
        # Parents should be created before children
        predefined_list = PredefinedFacility.where(code: codes)
        parents = predefined_list.where(parent_code: nil)
        children = predefined_list.where.not(parent_code: nil)

        # Create parents first
        [parents, children].each do |group|
          group.each do |predefined|
            # Skip if already exists
            next if current_program.facilities.exists?(code: predefined.code, default: true)

            # Find or create parent if exists
            parent_id = nil
            if predefined.parent_code.present?
              parent = current_program.facilities.find_or_initialize_by(code: predefined.parent_code, default: true)
              if parent.new_record?
                parent_predefined = PredefinedFacility.find_by(code: predefined.parent_code)
                
                if parent_predefined.nil?
                  Rails.logger.warn("Parent predefined facility not found: #{predefined.parent_code}")
                  next
                end
                
                parent.assign_attributes(
                  name_en: parent_predefined.name_en,
                  name_km: parent_predefined.name_km,
                  program_id: current_program.id
                )
                authorize parent
                parent.save!
              end
              parent_id = parent.id
            end

            # Find category if exists
            category_id = nil
            if predefined.category_code.present?
              category = Category.find_by(code: predefined.category_code)
              if category.nil?
                Rails.logger.warn("Category not found for code: #{predefined.category_code}")
              end
              category_id = category&.id
            end

            facility = authorize current_program.facilities.new(
              code: predefined.code,
              name_en: predefined.name_en,
              name_km: predefined.name_km,
              parent_id: parent_id,
              category_id: category_id,
              default: true
            )
            facility.save!
            created_facilities << facility
          end
        end
      end

      redirect_to facilities_url, notice: "#{created_facilities.count} facilities created successfully."
    rescue ActiveRecord::RecordInvalid => e
      redirect_to new_facility_path, alert: "Error creating facilities: #{e.message}"
    end
end
