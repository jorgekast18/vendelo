class ApplicationController < ActionController::Base
  around_action :switch_locale

  def switch_locale(&action)
    I18n.with_locale(locale_from_params, &action)
  end

  private
  def locale_from_params
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
end
