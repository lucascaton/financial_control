class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user]

    if @user.save
      flash[:notice] = 'Usuário criado com sucesso.'
      redirect_to @user
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]

    if @user.update_attributes params[:user]
      flash[:notice] = 'Usuário atualizado com sucesso.'
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find params[:id]
    # @user.destroy
    flash[:notice] = 'Usuário desativado com sucesso.'
    redirect_to users_path
  end
end
