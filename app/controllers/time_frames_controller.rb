class TimeFramesController < ApplicationController
  def show
    @time_frame = TimeFrame.find params[:id]
    @entries = @time_frame.entries.active.order 'bill_on'
  end
end
