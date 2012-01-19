require 'integration_helper'

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
end
