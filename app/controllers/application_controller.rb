# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  def ensure_admin_user
    unless current_user.admin?
      redirect_to root_path,
        flash: { error: 'Você não tem permissão para acessar esse recurso.' }
    end
  end
end
