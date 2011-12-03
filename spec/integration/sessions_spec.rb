require 'integration_helper'

feature 'Users sessions', %q{
  In order to use the application and close my session
  As an user
  I want to sign in and sign out
} do

  scenario 'Signing in with a simple user' do
    create_or_find_a_simple_user
    authenticate_with_email
    page.should have_content('Login realizado com sucesso!')
  end

  scenario 'Trying to sign in with a wrong password' do
    create_or_find_a_simple_user
    authenticate_with_email(email = 'stephenking@example.com', password = 'wrong-secret')
    page.should have_content('Email ou senha inválidos.')
  end

  scenario 'Signing in with a admin user' do
    create_or_find_a_admin_user
    authenticate_with_admin_email
    page.should have_content('Login realizado com sucesso!')
  end

  scenario 'Signing out' do
    create_or_find_a_simple_user
    authenticate_with_email
    sign_out
    page.should have_content('Para continuar, faça login!')
  end

  scenario 'Trying to sign in with a inactive user' do
    create_or_find_a_inactive_user
    authenticate_with_inactive_email
    page.should have_content('Email ou senha inválidos.')
  end
end
