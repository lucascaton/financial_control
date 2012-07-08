# encoding: utf-8
require 'integration_tests_helper'

feature 'Entries management', %q{
  In order to create and edit entries
  As an admin user
  I want to manage entries
} do

  background do
    create_or_find_a_admin_user
    authenticate_with_admin_email
    @time_frame = FactoryGirl.create :time_frame,
      :start_on => Date.today.beginning_of_month, :end_on => Date.today.end_of_month
  end

  scenario "Listing all time frame's entries" do
    entry = FactoryGirl.create :entry, :time_frame => @time_frame, :bill_on => Date.today
    visit time_frame_path(@time_frame)
    page.should have_content(I18n.l entry.bill_on)
    page.should have_content(entry.title)
    page.should have_content(entry.description)
  end

  scenario 'Show message when there is no entries' do
    visit time_frame_path(@time_frame)
    page.should have_content('Nenhuma conta cadastrada neste período.')
  end

  scenario 'Creating a new entry', :js => true do
    visit time_frame_path(@time_frame)
    click_link 'new_entry_link'
    fill_in 'entry_title', :with => "Castle's rent"
    fill_in 'entry_description', :with => "My new castle's rent"
    fill_in 'entry_value', :with => '400000.00'
    fill_in 'entry_bill_on', :with => I18n.l(Date.today)
    click_button 'save_button'
    page.should have_content("Castle's rent")
    page.should have_content("My new castle's rent")
    page.should have_content('R$ 400.000,00')
    page.should have_content(I18n.l Date.today)
  end

  scenario 'Trying to create a new entry without a title', :js => true do
    visit time_frame_path(@time_frame)
    click_link 'new_entry_link'
    fill_in 'entry_description', :with => "My new castle's rent"
    fill_in 'entry_value', :with => '400000.00'
    fill_in 'entry_bill_on', :with => I18n.l(Date.today)
    click_button 'save_button'
    page.should have_content('Título não pode ficar em branco')
  end

  scenario 'Trying to create a new entry with a invalid period', :js => true do
    visit time_frame_path(@time_frame)
    click_link 'new_entry_link'
    fill_in 'entry_title', :with => "Castle's rent"
    fill_in 'entry_description', :with => "My new castle's rent"
    fill_in 'entry_value', :with => '400000.00'
    fill_in 'entry_bill_on', :with => I18n.l(1.month.ago.to_date)
    click_button 'save_button'
    page.should have_content('Data de cobrança não é compatível com período atual')
  end

  scenario 'Removing a entry', :js => true do
    pending
  end

  scenario 'Trying to remove a entry', :js => true do
    pending
  end

  scenario "Editing a entry's title", :js => true do
    entry = FactoryGirl.create :entry, :time_frame => @time_frame, :title => "Castle's rent"
    visit time_frame_path(@time_frame)
    find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]").click
    find(:xpath, '//h3[@id="entry_title"]').click
    fill_in 'inplace_value', :with => 'New title'
    click_button 'Salvar'
    find(:xpath, '//h3[@id="entry_title"]').should have_content('New title')
    td = find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]/td[@id=\"td_entry_title\"]")
    td.should have_content('New title')
  end

  scenario "Editing a entry's kind", :js => true do
    entry = FactoryGirl.create :entry, :title => "Castle's rent", :time_frame => @time_frame,
      :bill_on => Date.today, :kind => 'credit', :value => 1000
    visit time_frame_path(@time_frame)
    find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]").click
    find(:xpath, '//div[@id="entry_kind"]').click
    select 'Débito (-)', :from => 'inplace_value'
    click_button 'Salvar'
    find(:xpath, '//div[@id="entry_kind"]').should have_content('Débito (-)')
    td = find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]/td[@id=\"td_entry_debit\"]")
    td.should have_content('R$ 1.000,00')
  end

  scenario "Editing a entry's description", :js => true do
    entry = FactoryGirl.create :entry, :time_frame => @time_frame, :description => "My new castle's rent"
    visit time_frame_path(@time_frame)
    find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]").click
    find(:xpath, '//div[@id="entry_description"]').click
    fill_in 'inplace_value', :with => 'New description'
    click_button 'Salvar'
    find(:xpath, '//div[@id="entry_description"]').should have_content('New description')
    td = find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]/td[@id=\"td_entry_description\"]")
    td.should have_content('New description')
  end

  scenario "Editing a entry's value", :js => true do
    entry = FactoryGirl.create :entry, :time_frame => @time_frame, :kind => 'debit', :value => 1000
    visit time_frame_path(@time_frame)
    find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]").click
    find(:xpath, '//div[@id="entry_value"]').click
    fill_in 'inplace_value', :with => '1200,00'
    click_button 'Salvar'
    find(:xpath, '//div[@id="entry_value"]').should have_content('R$ 1.200,00')
    td = find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]/td[@id=\"td_entry_debit\"]")
    td.should have_content('R$ 1.200,00')
  end

  scenario "Editing a entry's bill_on", js: true do
    entry = FactoryGirl.create :entry, time_frame: @time_frame, bill_on: Date.today.end_of_month - 1.day
    visit time_frame_path(@time_frame)
    find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]").click
    find(:xpath, '//div[@id="entry_bill_on"]').click
    fill_in 'inplace_value', :with => I18n.l(Date.today.end_of_month - 1.day)
    click_button 'Salvar'
    find(:xpath, '//div[@id="entry_bill_on"]').should have_content(I18n.l(Date.today.end_of_month - 1.day))
    td = find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]/td[@id=\"td_entry_bill_on\"]")
    td.should have_content(I18n.l(Date.today.end_of_month - 1.day))
  end

  scenario "Editing a entry's auto debit", :js => true do
    entry = FactoryGirl.create :entry, :time_frame => @time_frame, :auto_debit => false
    visit time_frame_path(@time_frame)
    find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]").click
    find(:xpath, '//div[@id="entry_auto_debit"]').click
    select 'Sim', :from => 'inplace_value'
    click_button 'Salvar'
    find(:xpath, '//div[@id="entry_auto_debit"]').should have_content('Sim')
  end

  scenario "Editing a entry's status", :js => true do
    entry = FactoryGirl.create :entry, :time_frame => @time_frame, :done => false
    visit time_frame_path(@time_frame)
    find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]").click
    find(:xpath, '//div[@id="entry_status"]').click
    select 'Pago!', :from => 'inplace_value'
    click_button 'Salvar'
    find(:xpath, '//div[@id="entry_status"]').should have_content('Pago')
    td = find(:xpath, "//table/tbody/tr[@id=\"entry_#{entry.id}\"]/td[@id=\"td_entry_status\"]")
    td.should have_content('Pago')
  end
end
