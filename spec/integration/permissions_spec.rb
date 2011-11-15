require 'integration_helper'

feature 'Permissions' do
  scenario "I can see the users management's link when I am a admin user" do
    create_or_find_admin_user
    authenticate_with_admin_email
    page.should have_content('Usuários')
  end

  scenario "I cannot see the users management's link when I am not a admin user" do
    create_or_find_simple_user
    authenticate_with_email
    page.should_not have_content('Usuários')
  end
end
