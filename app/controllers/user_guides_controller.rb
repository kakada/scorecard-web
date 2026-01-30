# frozen_string_literal: true

class UserGuidesController < ApplicationController
  def index
    @user_guides = available_guides
    authorize :user_guide
  end

  private
    def available_guides
      guides = []
      
      # Define available guides based on user role
      if current_user.system_admin?
        guides << { name: 'System Admin User Guide', file: 'system_admin_guide.pdf', key: 'system_admin' }
        guides << { name: 'Program Admin User Guide', file: 'program_admin_guide.pdf', key: 'program_admin' }
        guides << { name: 'Staff/Officer User Guide', file: 'staff_guide.pdf', key: 'staff' }
        guides << { name: 'Local NGO User Guide', file: 'lngo_guide.pdf', key: 'lngo' }
        guides << { name: 'DCSC Mobile App User Guide', file: 'mobile_app_guide.pdf', key: 'mobile_app' }
      elsif current_user.program_admin?
        guides << { name: 'Program Admin User Guide', file: 'program_admin_guide.pdf', key: 'program_admin' }
        guides << { name: 'Staff/Officer User Guide', file: 'staff_guide.pdf', key: 'staff' }
        guides << { name: 'Local NGO User Guide', file: 'lngo_guide.pdf', key: 'lngo' }
        guides << { name: 'DCSC Mobile App User Guide', file: 'mobile_app_guide.pdf', key: 'mobile_app' }
      elsif current_user.staff?
        guides << { name: 'Staff/Officer User Guide', file: 'staff_guide.pdf', key: 'staff' }
        guides << { name: 'Local NGO User Guide', file: 'lngo_guide.pdf', key: 'lngo' }
        guides << { name: 'DCSC Mobile App User Guide', file: 'mobile_app_guide.pdf', key: 'mobile_app' }
      elsif current_user.lngo?
        guides << { name: 'Local NGO User Guide', file: 'lngo_guide.pdf', key: 'lngo' }
        guides << { name: 'DCSC Mobile App User Guide', file: 'mobile_app_guide.pdf', key: 'mobile_app' }
      end

      guides
    end
end
