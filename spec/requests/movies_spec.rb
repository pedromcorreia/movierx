# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movies', type: :request do
  describe 'GET /mvoies' do
    context 'when params is valid' do
      ['Action', 'Science Fiction', 'Science+Fiction'].each do |genre|
        it 'render correct json with valid params' do
          get movies_path, params: { genre: genre, limit: '1', offset: '10' }
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['data'].keys).to eq(['movies'])
        end
      end

      it 'render correct json with missing params' do
        get movies_path, params: { genre: 'Action' }
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).keys).to eq(%w[data metadata errors])
        expect(JSON.parse(response.body)['data'].keys).to eq(['movies'])
      end
    end

    context 'when params is invalid' do
      ['invalid genre', 'Sciency Fuction', 'Sciency+Fuction'].each do |genre|
        it 'does not render with invalid gender' do
          get movies_path, params: { genre: genre }
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['errors']).to eq('invalid genre')
        end
      end
    end
  end
end
