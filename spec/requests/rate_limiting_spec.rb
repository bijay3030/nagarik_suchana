require 'rails_helper'

RSpec.describe 'Rate Limiting', type: :request do
  before do
    Rack::Attack.enabled = true
    Rack::Attack.reset!
  end

  after do
    Rack::Attack.reset!
  end

  describe 'POST /api/v1/auth/login' do
    it 'blocks after 5 failed attempts' do
      6.times do
        post '/api/v1/auth/login', params: {
          user: { email: 'test@test.com', password: 'wrong' }
        }, as: :json
      end

      expect(response.status).to eq(429)
      body = JSON.parse(response.body)
      expect(body['code']).to eq('RATE_LIMITED')
      expect(response.headers['Retry-After']).to be_present
    end
  end
end
