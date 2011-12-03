require 'integration_helper'

feature 'Users management', %q{
  In order to organize users
  As an admin user
  I want to manage users
} do

  background do
    create_or_find_a_admin_user
    authenticate_with_admin_email
  end

  scenario 'Creating a VALID new user' do
    visit new_user_path
    fill_in 'Nome', :with => 'John Doe'
    fill_in 'E-mail', :with => 'johndoe@example.com'
    fill_in 'Senha', :with => 'secret'
    fill_in 'Confirmação de senha', :with => 'secret'
    click_button 'Salvar'
    page.should have_content('Usuário criado com sucesso')
    page.should have_content('johndoe@example.com')
  end

  scenario 'Creating a INVALID new user' do
    visit new_user_path
    click_button 'Salvar'
    page.should have_content('Nome não pode ficar em branco')
    page.should have_content('E-mail não pode ficar em branco')
    page.should have_content('Senha não pode ficar em branco')
  end

  scenario 'Creating a new user with diferent password and confirmation' do
    visit new_user_path
    fill_in 'Nome', :with => 'John Doe'
    fill_in 'E-mail', :with => 'johndoe@example.com'
    fill_in 'Senha', :with => 'secret'
    fill_in 'Confirmação de senha', :with => 'wrong_password'
    click_button 'Salvar'
    page.should have_content('Senha não bate com a confirmação')
  end

  scenario 'Editing a user' do
    user = FactoryGirl.create :user, :name => 'Mario'
    visit "users/#{user.id}/edit"
    fill_in 'Nome', :with => 'Luigi'
    click_button 'Salvar'
    page.should have_content('Usuário atualizado com sucesso')
    page.should have_content('Luigi')
  end
end
