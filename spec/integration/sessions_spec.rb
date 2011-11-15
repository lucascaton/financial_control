require 'integration_helper'

feature 'Users sessions' do
  scenario 'Signing in' do
    create_or_find_stephen_king_user
    authenticate_with_email
    page.should have_content('Login realizado com sucesso')
  end

  scenario 'Signing out' do
    create_or_find_stephen_king_user
    authenticate_with_email
    sign_out
    page.should have_content('Para continuar, faça login!')
  end
end
