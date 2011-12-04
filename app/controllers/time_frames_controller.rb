class TimeFramesController < ApplicationController
  def show
    @time_frame = TimeFrame.find params[:id]
  end
end
