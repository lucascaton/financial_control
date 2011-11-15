class UsersController < ApplicationController
  before_filter :ensure_admin_user

  def index
    @users = User.order('name')
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user]

    if @user.save
      flash[:notice] = 'Usuário criado com sucesso.'
      redirect_to users_path
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]

    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?

    if @user.update_attributes params[:user]
      flash[:notice] = 'Usuário atualizado com sucesso.'
      redirect_to users_path
    else
      render :action => 'edit'
    end
  end
end
