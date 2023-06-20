class PassthroughController < ApplicationController
  def index
      path = case current_user.role
      when 'school_admin'
        school_path(current_user.school_id)
      else
        schools_path
      end
  
      redirect_to path     
  end
end
