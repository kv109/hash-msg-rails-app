require 'rails_helper'

describe 'messages', type: :request do
  describe 'create message' do
    context 'with invalid params' do
      it 'should return 422' do
        req :post, 'messages', password: ''
        expect(response_code).to eq(422)
        expect(response_hash).to have_key('error')
        expect(response_hash['error']).to eq(["Decrypted content can't be blank", "Decrypted content is too short (minimum is 6 characters)", "Password can't be blank", "Password is too short (minimum is 6 characters)"])
      end
    end

    context 'with valid params' do
      context 'with password' do
        it 'should create encrypted message' do
          create_message_with_password('decrypted content', 'strong password')
          expect(response_hash).to have_key('uuid')
        end
      end

      context 'with token' do
        it 'should create encrypted message' do
          create_message_with_token('decrypted content')
          expect(response_hash).to have_key('token')
          expect(response_hash).to have_key('uuid')
        end
      end
    end
  end

  describe 'show message' do
    context 'with invalid uuid' do
      it 'should return 404' do
        req :post, "messages/fake-uuid"
        expect(response_code).to eq(404)
      end
    end

    context 'encrypted with password' do
      context 'with invalid password' do
        it 'should return 422' do
          decrypted_content = 'decrypted content'
          password          = 'strong password'

          create_message_with_password(decrypted_content, password)
          uuid = response_hash.fetch('uuid')

          req :post, "messages/#{uuid}", password: 'invalid password'

          expect(response_code).to eq(422)
          expect(response_hash).to have_key('error')
          expect(response_hash['error']).to eq(['wrong password'])
        end
      end

      context 'with valid params' do
        it 'should return decrypted content' do
          decrypted_content = 'decrypted content'
          password          = 'strong password'

          create_message_with_password(decrypted_content, password)
          uuid = response_hash.fetch('uuid')

          req :post, "messages/#{uuid}", password: password
          expect(response_hash).to have_key('decrypted_content')
          expect(response_hash['decrypted_content']).to eq(decrypted_content)

          req :post, "messages/#{uuid}", password: password
          expect(response_code).to eq(404)
        end
      end
    end

    context 'encrypted with token' do
      context 'with invalid token' do
        it 'should return 422' do
          create_message_with_token('decrypted content')
          uuid = response_hash.fetch('uuid')

          req :get, "messages/#{uuid}/invalid-token"

          expect(response_code).to eq(422)
          expect(response_hash).to have_key('error')
          expect(response_hash['error']).to eq(['wrong password'])
        end
      end

      context 'with valid token' do
        it 'should return decrypted content' do
          decrypted_content = 'decrypted content'

          create_message_with_token(decrypted_content)
          token = response_hash.fetch('token')
          uuid  = response_hash.fetch('uuid')

          req :get, "messages/#{uuid}/#{token}"
          expect(response_hash).to have_key('decrypted_content')
          expect(response_hash['decrypted_content']).to eq(decrypted_content)

          req :get, "messages/#{uuid}/#{token}"
          expect(response_code).to eq(404)
        end

        context 'with output=raw' do
          it 'should return decrypted content as plain text' do
            decrypted_content = 'decrypted content'

            create_message_with_token(decrypted_content)
            token = response_hash.fetch('token')
            uuid  = response_hash.fetch('uuid')

            req :get, "messages/#{uuid}/#{token}", output: :raw
            expect(response_body).to eq(decrypted_content)

            expect(last_response.headers['Content-Type']).to eq('text/plain; charset=utf-8')
          end
        end
      end
    end
  end

  def create_message_with_password(decrypted_content, password)
    req :post, 'messages', decrypted_content: decrypted_content, password: password
  end

  def create_message_with_token(decrypted_content)
    req :post, 'messages', decrypted_content: decrypted_content
  end
end
