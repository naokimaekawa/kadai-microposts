class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
　
　#Helper に定義していた logged_in? を使用しているが、
　#Controller から Helper のメソッドを使うことはデフォルトではできないため
　include SessionsHelper

  private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
end