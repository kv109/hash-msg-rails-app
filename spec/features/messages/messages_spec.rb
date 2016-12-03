feature 'Messages' do

  scenario 'Create and decrypt message', js: true do
    # Create and enter correct password
    visit root_path
    fill_in 'Message', with: 'Foobar'
    fill_in 'Password', with: 'password'
    click_button 'Submit'
    fill_in 'Password', with: 'password'
    click_button 'Submit'
    expect(page).to have_selector('pre', text: 'Foobar')

    # Create and enter wrong password
    visit root_path
    fill_in 'Message', with: 'Foobar'
    fill_in 'Password', with: 'password'
    click_button 'Submit'
    fill_in 'Password', with: 'WRONG PASSWORD'
    click_button 'Submit'
    expect(page).to have_selector('h5', text: 'bad decrypt')
  end

end
