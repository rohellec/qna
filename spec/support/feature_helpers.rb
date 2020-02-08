module FeatureHelpers
  def sign_up(attributes = {})
    visit sign_up_path
    fill_in "Email", with: attributes[:email]
    fill_in "Password", with: attributes[:password]
    fill_in "Password confirmation", with: attributes[:password_confirmation]
    click_on "Sign up"
  end
end
