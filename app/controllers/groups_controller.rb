class GroupsController < ApplicationController
  before_filter :ensure_admin_user

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find params[:id]
    @users_to_add_to_group = User.active - @group.users
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new params[:group]

    if @group.save
      flash[:notice] = 'Grupo criado com sucesso.'
      redirect_to @group
    else
      render :action => 'new'
    end
  end

  def edit
    @group = Group.find params[:id]
  end

  def update
    @group = Group.find params[:id]

    if @group.update_attributes params[:group]
      flash[:notice] = 'Grupo atualizado com sucesso.'
      redirect_to @group
    else
      render :action => 'edit'
    end
  end

  def add_user
    @group = Group.find params[:id]
    user = User.find params[:add_user][:user_id]
    @group.users << user

    flash[:notice] = "Usuário \"#{user.name}\" adicionado com sucesso neste grupo."
    redirect_to @group
  end
end
