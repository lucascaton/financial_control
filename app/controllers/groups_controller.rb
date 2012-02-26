# encoding: utf-8

class GroupsController < ApplicationController
  before_filter :ensure_admin_user
  before_filter :load_group, :only => [:show, :edit, :update, :add_user, :remove_user, :time_frames, :add_time_frame, :remove_time_frame]

  def index
    @groups = Group.all
  end

  def show
    @users_to_add_to_group = (User.active - @group.users).sort_by &:name
    flash.now[:error] = 'Nenhum usuário cadastrado neste grupo.' if @group.users.empty?
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
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update_attributes params[:group]
      flash[:notice] = 'Grupo atualizado com sucesso.'
      redirect_to @group
    else
      render :edit
    end
  end

  def add_user
    @group = Group.find params[:id]
    user = User.find params[:add_user][:user_id]
    @group.users << user

    flash[:notice] = "Usuário \"#{user.name}\" adicionado com sucesso neste grupo."
    redirect_to @group
  end

  def remove_user
    user = User.find params[:user_id]
    @group.users.delete user

    flash[:notice] = "Usuário \"#{user.name}\" removido com sucesso deste grupo."
    redirect_to @group
  end

  def time_frames
    @time_frames = @group.time_frames
    flash.now[:error] = @group.time_frame_errors if @group.time_frame_errors
  end

  def add_time_frame
    start_on = Date.civil params[:add_time_frame]['period(1i)'].to_i, params[:add_time_frame]['period(2i)'].to_i, 1
    end_on = start_on.end_of_month

    time_frame = TimeFrame.new :group_id => @group.id, :start_on => start_on, :end_on => end_on

    if time_frame.save
      flash[:notice] = "Período \"#{time_frame.period}\" adicionado com sucesso neste grupo."
    else
      flash[:error] = 'Não foi possível adicionar esse período.'
    end
    redirect_to time_frames_group_path(@group)
  end

  def remove_time_frame
    time_frame = TimeFrame.find params[:time_frame_id]

    if time_frame.destroyable? && time_frame.destroy
      flash[:notice] = 'Período removido com sucesso.'
    else
      flash[:error] = 'Não foi possível remover esse período.'
    end

    redirect_to time_frames_group_path(@group)
  end

  private
  def load_group
    @group = Group.find params[:id]
  end
end
