feature 'Messages' do

  scenario 'Create message', js: true do
    # With correct password
    visit root_path
    fill_in 'Message', with: 'Foobar'
    fill_in 'Password', with: 'password'
    click_button 'Submit'
    fill_in 'Password', with: 'password'
    click_button 'Submit'
    expect(page).to have_selector('pre', text: 'Foobar')

    # With wrong password
    visit root_path
    fill_in 'Message', with: 'Foobar'
    fill_in 'Password', with: 'password'
    click_button 'Submit'
    fill_in 'Password', with: 'WRONG PASSWORD'
    click_button 'Submit'
    expect(page).to have_selector('h5', text: 'wrong password')

    # With blank message
    visit root_path
    fill_in 'Message', with: ''
    fill_in 'Password', with: 'password'
    click_button 'Submit'
    expect_error("Message can't be blank")

    # With password with less than 6 characters
    visit root_path
    fill_in 'Message', with: 'Foobar'
    fill_in 'Password', with: '12345'
    click_button 'Submit'
    expect_error('Password is too short (minimum is 6 characters)')
  end

  def expect_error(message)
    within 'form' do
      expect(page).to have_selector('#error_explanation', text: 'Error!')
      expect(page).to have_selector('li', text: message)
    end
  end
end
