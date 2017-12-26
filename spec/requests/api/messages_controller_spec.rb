require 'rails_helper'

describe 'messages', type: :request do
  context 'with invalid params' do
    it 'returns 422' do
      req :post, 'messages'
      expect(response_code).to eq(422)
      expect(response_hash).to have_key('error')
    end
  end

  context 'with valid params' do
    it do
      req :post, 'messages', decrypted_content: 'decrypted content', password: 'strong password'
      expect(response_hash).to have_key('curl')
      expect(response_hash['curl']).to match(/curl -X POST -d password/)
    end
  end
end
