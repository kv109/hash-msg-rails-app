feature 'Messages' do

  scenario 'Create message', js: true do
    # With correct password
    visit root_path
    within create_form do
      fill_in 'Message', with: 'Foobar'
      fill_in 'Password', with: 'password'
      click_button 'Submit'
    end
    within decrypt_form do
      fill_in 'Password', with: 'password'
      click_button 'Submit'
    end
    expect(page).to have_selector('pre', text: 'Foobar')

    # Refresh page to check if message was deleted
    page.driver.go_back
    within decrypt_form do
      fill_in 'Password', with: 'password'
      click_button 'Submit'
    end
    within '.message-not-found' do
      screenshot_and_save_page
      expect(page).to have_content('Message not found.')
    end

    # With wrong password
    visit root_path
    within create_form do
      fill_in 'Message', with: 'Foobar'
      fill_in 'Password', with: 'password'
      click_button 'Submit'
    end
    within decrypt_form do
      fill_in 'Password', with: 'WRONG PASSWORD'
      click_button 'Submit'
    end
    expect(page).to have_selector('h5', text: 'wrong password')

    # With blank message
    visit root_path
    within create_form do
      fill_in 'Message', with: ''
      fill_in 'Password', with: 'password'
      click_button 'Submit'
    end
    expect_html5_validation_to_prevent_submit

    # With password with less than 6 characters
    visit root_path
    within create_form do
      fill_in 'Message', with: 'Foobar'
      fill_in 'Password', with: '12345'
      click_button 'Submit'
    end
    expect_html5_validation_to_prevent_submit
  end

  def create_form
    '#new_encrypted_message_create_form'
  end

  def decrypt_form
    '#decrypt_encrypted_message_form'
  end

  def expect_html5_validation_to_prevent_submit
    expect(current_path).to eql root_path
  end
end
