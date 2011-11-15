module IntegrationHelpers
  def create_or_find_stephen_king_user
    user = User.find_by_email 'stephenking@example.com'
    user ||= FactoryGirl.create :user, {
      :name                  => 'Stephen King',
      :email                 => 'stephenking@example.com',
      :password              => 'secret'
    }
    user.save!
  end

  def authenticate_with_email
    visit root_path
    fill_in 'E-mail', :with => 'stephenking@example.com'
    fill_in 'Senha', :with => 'secret'
    click_button 'Autenticar'
  end

  def sign_out
    visit destroy_user_session_path
  end
end
