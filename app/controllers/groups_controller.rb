class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find params[:id]
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
end
