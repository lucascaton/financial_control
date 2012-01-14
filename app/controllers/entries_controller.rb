class EntriesController < ApplicationController
  def show
    @entry = Entry.find params[:id]
    render :layout => false
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
          I18n.t entry.done.to_s
        else
          entry.send(attribute)
        end

      render :json => data
    else
      render :json => nil
    end
  end
end
