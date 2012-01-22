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
    update_value = case attribute
      when :value
        params[:update_value].gsub(/,/, '.')
      when :bill_on
       Date.strptime params[:update_value], '%d/%m/%Y'
      else
        params[:update_value]
      end

    if entry.update_attributes attribute => update_value
      data = case attribute
        when :kind
          entry.kind_humanize
        when :value
          entry.value.to_currency Currency::BRL
        when :bill_on
          I18n.l entry.bill_on
        when :auto_debit
          I18n.t entry.auto_debit.to_s
        when :done
          EntryStatus.t entry.status
        else
          entry.send(attribute)
        end

      render :json => data
    else
      render :json => nil
    end
  end
end
