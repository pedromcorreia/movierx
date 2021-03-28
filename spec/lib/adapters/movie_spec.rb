# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Adapter::Adapters::Movie do
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
    subject(:subject_class) { described_class.new(value).call }
    let(:response) { JSON(subject_class.body) }
    let(:data) { JSON(subject_class.body)['data'].first }

    context 'call describe class with movie type' do
      let(:value) { { query: 1724 } }
      let(:title) { 'The Incredible Hulk' }
      it 'response with valid status' do
        VCR.use_cassette(title, record: :once) do
          expect(subject_class.status).to eql(200)
        end
      end

      it 'response with valid movie infos' do
        VCR.use_cassette(title, record: :once) do
          expect(response.keys).to match_array(%w[metadata data])
          expect(data['id']).to eql(value[:query])
          expect(data['title']).to eql(title)
          expect(data['genres']).to eql([878, 28, 12])
          expect(data['cast']).to eql([819, 882, 3129, 227, 1462, 15_232, 68_277])
        end
      end
    end

    context 'call describe class with inexisten cast' do
      let(:value) { { query: -1 } }
      let(:title) { 'Not existent movie' }

      it 'response with valid status' do
        VCR.use_cassette(title, record: :once) do
          expect(subject_class.status).to eql(200)
        end
      end

      it 'response with valid movie infos' do
        VCR.use_cassette(title, record: :once) do
          expect(data).to be_nil
        end
      end
    end

    context 'call describe class with 500 error' do
      let(:value) { { query: -1 } }
      let(:title) { '500_movie' }

      it 'response with valid status' do
        VCR.use_cassette(title, record: :once) do
          expect(subject_class.status).to eql(500)
        end
      end
    end
  end
end
