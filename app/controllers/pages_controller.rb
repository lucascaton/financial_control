# encoding: utf-8

class PagesController < ApplicationController
  def index
    @groups = Group.all
  end

  def licence; end
end
