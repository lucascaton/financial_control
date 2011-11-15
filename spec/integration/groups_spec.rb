require 'integration_helper'

feature 'Groups management' do
  background do
    create_or_find_a_admin_user
    authenticate_with_admin_email
  end

  scenario 'Creating a VALID new group' do
    visit new_group_path
    fill_in 'Nome', :with => 'Reynholm Industries'
    click_button 'Salvar'
    page.should have_content('Grupo criado com sucesso')
    page.should have_content('Reynholm Industries')
  end

  scenario 'Creating a INVALID new group' do
    visit new_group_path
    click_button 'Salvar'
    page.should have_content('Nome não pode ficar em branco')
  end

  scenario 'Editing a group' do
    group = FactoryGirl.create :group, :name => 'Home Finances'
    visit "groups/#{group.id}/edit"
    fill_in 'Nome', :with => 'Company'
    click_button 'Salvar'
    page.should have_content('Grupo atualizado com sucesso')
    page.should have_content('Company')
  end

  scenario 'Adding a user to a group' do
    user = FactoryGirl.create :user, :name => 'Frodo', :email => 'frodo@example.com'
    group = FactoryGirl.create :group, :name => 'Home Finances'
    visit "groups/#{group.id}"
    select 'Frodo (frodo@example.com)', :from => 'Adicionar usuário:'
    click_button 'Incluir neste grupo'
    page.should have_content('Usuário "Frodo" adicionado com sucesso neste grupo.')
  end
end
