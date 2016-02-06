class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_platform_admin?
  helper_method :current_lister?
  helper_method :current_contractor?
  helper_method :all_categories

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_platform_admin?
    current_user && current_user.platform_admin?
  end

  def current_lister?
    current_user && current_user.lister?
  end

  def current_contractor?
    current_user && current_user.contractor?
  end

  def sanitize_price(price)
    price.to_s.gsub!(/[,$]/, "").to_i
  end

  def all_categories
    @all_categories ||= Category.all
  end

  def logged_in?
    current_user
  end
end
