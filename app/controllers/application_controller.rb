class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :avatar, :username ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :avatar, :username ])
  end

  def after_sign_in_path_for(resource)
    flash[:notice] = "Signed in successfully."
    posts_path
  end
end
