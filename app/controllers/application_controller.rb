class ApplicationController < ActionController::Base
  include DeviseFlashKeysSwitched

  before_action :authenticate_user!

  private

  def resource_name
    controller_name.singularize
  end

  def resource
    send(resource_name)
  end

  def redirect_if_not_author
    return if current_user.author_of?(resource)
    flash[:danger] = "You need to be an author of #{resource_name}"
    redirect_to root_url
  end
end
