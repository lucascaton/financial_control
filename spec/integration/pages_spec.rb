# encoding: utf-8
require 'integration_tests_helper'

feature 'Pages', %q{
  In order to see the static pages
  As an simple user
  I want to see the correct informations
} do

  background do
    create_or_find_a_simple_user
    authenticate_with_email
  end

  scenario 'Visiting homepage when there are no groups' do
    visit root_path
    page.should have_content('Bem-vindo!')
    page.should have_content('Você ainda não criou nenhum grupo.')
  end
end
