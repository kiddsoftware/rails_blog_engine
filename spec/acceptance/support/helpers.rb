module RailsBlogEngine::AcceptanceHelperMethods
  # Put helper methods you need to be available in all acceptance specs here.

  # In our test application, any user counts as an administrator.
  def sign_in_as_admin
    saved_path = current_path
    visit '/users/sign_up'
    fill_in 'Email', :with => "sue@example.com"
    fill_in 'Password', :with => "password"
    fill_in 'Password confirmation', :with => "password"
    click_button 'Sign up'
    visit saved_path
  end
end

RSpec.configuration.include(RailsBlogEngine::AcceptanceHelperMethods,
                            :example_group =>
                              { :file_path => /spec\/acceptance/ })
