require 'integration_helper'

feature 'Menu permissions' do
  context 'when I am a admin user' do
    background do
      create_or_find_a_admin_user
      authenticate_with_admin_email
    end

    scenario "I can see the users management's link" do
      page.should have_content('Usuários')
    end

    scenario "I can see the group management's link" do
      page.should have_content('Grupos')
    end
  end

  context 'when I am NOT a admin user' do
    background do
      create_or_find_a_simple_user
      authenticate_with_email
    end

    scenario "I cannot see the users management's link" do
      page.should_not have_content('Usuários')
    end

    scenario "I cannot see the group management's link" do
      page.should_not have_content('Grupos')
    end
  end
end
