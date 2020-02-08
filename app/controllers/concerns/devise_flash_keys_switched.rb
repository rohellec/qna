module DeviseFlashKeysSwitched
  extend ActiveSupport::Concern

  included do
    after_action :switch_devise_flash_keys!, if: :devise_controller?
  end

  def switch_devise_flash_keys!(options = {})
    options.reverse_merge!(notice: :success, alert: :danger)
    flash.keys.each do |key|
      if (new_key = options[:"#{key}"])
        switch_flash_keys(key, new_key)
      end
    end
  end

  def switch_flash_keys(key, new_key)
    message = flash[key]
    flash.delete key
    flash[new_key] = message
  end
end
