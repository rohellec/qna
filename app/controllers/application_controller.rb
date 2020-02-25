class ApplicationController < ActionController::Base
  include DeviseFlashKeysSwitched

  before_action :authenticate_user!
end
