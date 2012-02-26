# encoding: utf-8

require 'integration_helper'

feature 'Time frame management', %q{
  In order to divide the time by periods
  As an admin user
  I want to manage time frames
} do

  background do
    create_or_find_a_admin_user
    authenticate_with_admin_email
    @group = FactoryGirl.create :group
  end

  scenario "Listing all group's time frames" do
    time_frame = FactoryGirl.create :time_frame, :group => @group
    visit time_frames_group_path(@group)
    page.should have_content(I18n.l(time_frame.start_on))
    page.should have_content(I18n.l(time_frame.end_on))
  end

  scenario 'Show message when there is no time frames' do
    visit time_frames_group_path(@group)
    page.should have_content('Nenhum período cadastrado neste grupo.')
  end

  scenario 'Show message when there is no active time frames' do
    time_frame = FactoryGirl.create :time_frame, :group => @group, :start_on => 2.month.ago, :end_on => 1.month.ago
    visit time_frames_group_path(@group)
    page.should have_content('Nenhum período ativo neste grupo.')
  end

  scenario 'Adding a time frame to a group' do
    visit "/groups/#{@group.id}/time_frames"
    select 'Dezembro', :from => 'add_time_frame_period_2i'
    select '2011', :from => 'add_time_frame_period_1i'
    click_button 'Adicionar'
    page.should have_content("Período \"01/12/2011 à 31/12/2011\" adicionado com sucesso neste grupo.")
  end

  scenario 'Trying to add a invalid time frame to a group' do
    time_frame = FactoryGirl.create :time_frame, :group => @group,
      :start_on => Date.today.beginning_of_month, :end_on => Date.today.end_of_month
    visit "/groups/#{@group.id}/time_frames"
    select I18n.l(Date.today, :format => :only_month), :from => 'add_time_frame_period_2i'
    select Date.today.year.to_s, :from => 'add_time_frame_period_1i'
    click_button 'Adicionar'
    page.should have_content('Não foi possível adicionar esse período.')
  end

  scenario 'Removing a time frame from a group', :js => true do
    time_frame = FactoryGirl.create :time_frame, :group => @group
    visit "/groups/#{@group.id}/time_frames"
    click_link("remove_time_frame_#{time_frame.id}")
    page.driver.browser.switch_to.alert.accept
    page.should have_content('Período removido com sucesso.')
  end

  scenario 'Trying to remove a time frame from a group' do
    pending
    time_frame = FactoryGirl.create :time_frame, :group => @group
    visit "/groups/#{@group.id}/time_frames"
    page.should_not have_content("remove_time_frame_#{time_frame.id}")
  end
end
