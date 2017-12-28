require 'rails_helper'

describe 'messages', type: :request do
  describe 'create message' do
    context 'with invalid params' do
      it 'should return 422' do
        req :post, 'messages'
        expect(response_code).to eq(422)
        expect(response_hash).to have_key('error')
        expect(response_hash['error']).to eq(["Decrypted content can't be blank", "Decrypted content is too short (minimum is 6 characters)", "Password can't be blank", "Password is too short (minimum is 6 characters)"])
      end
    end

    context 'with valid params' do
      it 'should create encrypted message' do
        create_message('decrypted content', 'strong password')
        expect(response_hash).to have_key('curl')
        expect(response_hash['curl']).to match(/curl -X POST -d password/)

        expect(response_hash).to have_key('uuid')
      end
    end
  end

  describe 'show message' do
    context 'with invalid password' do
      it 'should return 422' do
        decrypted_content = 'decrypted content'
        password          = 'strong password'

        create_message(decrypted_content, password)
        uuid = response_hash.fetch('uuid')

        req :post, "messages/#{uuid}", password: 'invalid password'

        expect(response_code).to eq(422)
        expect(response_hash).to have_key('error')
        expect(response_hash['error']).to eq(['wrong password'])
      end
    end

    context 'with invalid uuid' do
      it 'should return 404' do
        req :post, "messages/fake-uuid"
        expect(response_code).to eq(404)
      end
    end

    context 'with valid params' do
      it 'should return decrypted content' do
        decrypted_content = 'decrypted content'
        password          = 'strong password'

        create_message(decrypted_content, password)
        uuid = response_hash.fetch('uuid')

        req :post, "messages/#{uuid}", password: password
        expect(response_hash).to have_key('decrypted_content')
        expect(response_hash['decrypted_content']).to eq(decrypted_content)
      end
    end
  end

  def create_message(decrypted_content, password)
    req :post, 'messages', decrypted_content: decrypted_content, password: password
  end
end
