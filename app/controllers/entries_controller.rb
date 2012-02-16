class EntriesController < ApplicationController
  def show
    @entry = Entry.find params[:id]
    render :layout => false
  end

  def quick_create
    entry = Entry.new :time_frame_id => params[:time_frame_id], :kind => params[:kind],
      :title => params[:title], :description => params[:description], :value => params[:value],
      :bill_on => (params[:bill_on].present? ? Date.strptime(params[:bill_on], '%d/%m/%Y') : nil)

    if entry.save
      render :json => { :successful => true, :entry => entry }
    else
      render :json => { :successful => false, :errors => entry.errors.full_messages.first }
    end
  end

  def quick_update
    entry = Entry.find params[:id]
    attribute = params[:attribute].to_sym
    update_value = params[:update_value]

    render :json => entry.quick_update_attribute(attribute, update_value)
  end
end
