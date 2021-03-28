# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Adapter::Adapters::Genre do
  describe '.new' do
    subject(:subject_class) { described_class.new(value) }
    context 'when params is valid' do
      let(:value) { { query: 'query' } }
      it 'response with valid array keys' do
        expect(subject_class.query).to eql(value[:query])
      end
    end
  end

  describe '.call' do
    subject(:subject_class) do
      described_class.new(value).call
    end

    let(:response) { JSON(subject_class.body) }
    let(:data) { JSON(subject_class.body)['data'].first }

    context 'call describe class with movie type' do
      let(:genre) { 'Action' }
      let(:value) { { query: genre, type: :genre, limit: 1, offset: 1 } }
      it 'response with valid status' do
        VCR.use_cassette(genre, record: :once) do
          expect(subject_class.status).to eql(200)
        end
      end

      it 'response with valid movie infos' do
        VCR.use_cassette(genre, record: :once) do
          expect(response.keys).to eql(%w[metadata data])
          expect(data).to eq(1724)
        end
      end
    end

    context 'call describe class with inexisten genre' do
      let(:value) { { query: genre, type: :genre, limit: 1, offset: 1 } }
      let(:genre) { 'Not existent genre' }

      it 'response with valid status' do
        VCR.use_cassette(genre, record: :once) do
          expect(subject_class.status).to eql(404)
        end
      end

      it 'response with valid movie infos' do
        VCR.use_cassette(genre, record: :once) do
          expect(response).to eql({"error"=>"Genre Not existent genre is unknown"})
        end
      end
    end

    context 'call describe class with 500 error' do
      let(:value) { { query: -1 } }
      let(:genre) { '500_genre' }

      it 'response with valid status' do
        VCR.use_cassette(genre, record: :once) do
          expect(subject_class.status).to eql(500)
        end
      end
    end
  end
end
