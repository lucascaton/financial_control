require 'integration_helper'

feature 'Access permissions' do
  context 'when I am a admin user' do
    background do
      create_or_find_a_admin_user
      authenticate_with_admin_email
    end

    scenario 'I can access the users managetment page' do
      visit users_path
      page.should_not have_content('Você não tem permissão para acessar esse recurso.')
    end

    scenario 'I can access the groups managetment page' do
      visit groups_path
      page.should_not have_content('Você não tem permissão para acessar esse recurso.')
    end
  end

  context 'when I am NOT a admin user' do
    background do
      create_or_find_a_simple_user
      authenticate_with_email
    end

    scenario 'I CANNOT access the users managetment page' do
      visit users_path
      page.should have_content('Você não tem permissão para acessar esse recurso.')
    end

    scenario 'I CANNOT access the groups managetment page' do
      visit groups_path
      page.should have_content('Você não tem permissão para acessar esse recurso.')
    end
  end
end
