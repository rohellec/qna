module FeatureMacros
  def sign_up(attributes = {})
    visit sign_up_path
    fill_in :user_email, with: attributes[:email]
    fill_in :user_password, with: attributes[:password]
    fill_in :user_password_confirmation, with: attributes[:password_confirmation]
    click_button "Sign up"
  end

  def login(user)
    visit sign_in_path
    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    click_button "Sign in"
  end
end
