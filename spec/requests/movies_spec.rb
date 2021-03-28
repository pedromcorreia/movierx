# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Movies', type: :request do
  describe 'GET /movies' do
    context 'when params is valid' do
      ['Action', 'Science Fiction', 'Science+Fiction'].each do |genre|
        before(:all) do
          VCR.use_cassette(genre, record: :new_episodes) do
            get movies_path, params: { genre: genre, limit: '1', offset: '10' }
          end
        end
        it 'render correct valid response' do
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response).to have_http_status(:ok)
        end

        it 'render correct keys' do
          expect(JSON.parse(response.body)['data'].keys).to eq(['movies'])
          expect(JSON.parse(response.body).keys).to eq(%w[data metadata errors])
        end
      end

      context 'when missing params' do
        before(:context) do
          VCR.use_cassette('Action', record: :once) do
            get movies_path, params: { genre: 'Action' }
          end
        end

        it 'render correct valid response' do
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not render with invalid gender' do
          expect(JSON.parse(response.body)['errors']).to eq('limit or offset must be positive')
        end
      end
    end

    context 'when params is invalid' do
      ['invalid genre', 'Sciency Fuction', 'Sciency+Fuction'].each do |genre|
        before(:all) do
          VCR.use_cassette(genre) do
            get movies_path, params: { genre: genre }
          end
        end
        it 'render correct invalid response' do
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not render with invalid gender' do
          expect(JSON.parse(response.body)['errors']).to eq('invalid genre')
        end
      end
    end
  end
end
