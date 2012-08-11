# encoding: utf-8
class TimeFramesController < ApplicationController
  before_filter :load_time_frame_and_entries, only: [:show]

  def show
    flash[:error] = 'Nenhuma conta cadastrada neste período.' if @entries.empty?
  end

  def entries
    render :layout => false
  end

  private
  def load_time_frame_and_entries
    @time_frame = TimeFrame.find params[:id]
    @entries = @time_frame.entries.active.order 'bill_on'
  end
end
