module IntegrationHelpers
  def create_or_find_simple_user
    user = User.find_by_email 'stephenking@example.com'
    user ||= FactoryGirl.create :user, {
      :name                  => 'Stephen King',
      :email                 => 'stephenking@example.com',
      :password              => 'secret'
    }
    user.save!
  end

  def create_or_find_admin_user
    user = User.find_by_email 'admin@example.com'
    user ||= FactoryGirl.create :user, {
      :name                  => 'Admin',
      :email                 => 'admin@example.com',
      :password              => 'top-secret',
      :admin                 => true
    }
    user.save!
  end

  def authenticate_with_email(email = 'stephenking@example.com', password = 'secret')
    visit root_path
    fill_in 'E-mail', :with => email
    fill_in 'Senha', :with => password
    click_button 'Autenticar'
  end

  def authenticate_with_admin_email
    authenticate_with_email('admin@example.com', 'top-secret')
  end

  def sign_out
    visit destroy_user_session_path
  end
end
