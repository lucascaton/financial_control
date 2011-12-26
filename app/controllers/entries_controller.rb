class EntriesController < ApplicationController
  def show
    @entry = Entry.find params[:id]
    render :layout => false
  end

  def quick_update
    entry = Entry.find params[:id]
    attribute = params[:attribute].to_sym
    update_value = (attribute == :value) ? params[:update_value].gsub(/,/, '.') : params[:update_value]

    if entry.update_attributes attribute => update_value
      data = case attribute
        when :kind
          entry.kind_humanize
        when :value
          entry.value.to_currency Currency::BRL
        else
          entry.send(attribute)
        end

      render :json => data
    else
      render :json => nil
    end
  end
end
