class EntriesController < ApplicationController
  def show
    @entry = Entry.find params[:id]
    render :layout => false
  end

  def quick_update
    entry = Entry.find params[:id]
    attribute = params[:attribute].to_sym
    attribute_humanize = "#{attribute}_humanize".to_sym

    successful = entry.update_attributes attribute => params[:update_value]
    value = entry.respond_to?(attribute_humanize) ? entry.send(attribute_humanize) : entry.send(attribute)
    render :json => value
  end
end
