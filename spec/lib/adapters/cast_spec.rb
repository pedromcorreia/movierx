# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Adapter::Adapters::Cast do
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

    context 'call describe class with cast type' do
      let(:cast) { 'Edward Norton' }
      let(:value) { { query: 819, type: :cast } }
      it 'response with valid status' do
        VCR.use_cassette(cast, record: :once) do
          expect(subject_class.status).to eql(200)
        end
      end

      it 'response with valid cast infos' do
        VCR.use_cassette(cast, record: :once) do
          expect(data.keys).to match_array(%w[id name profilePath gender movies])
          expect(data['name']).to eql(cast)
        end
      end
    end

    context 'call describe class with inexisten cast' do
      let(:value) { { query: -1, type: :cast } }
      let(:cast) { 'Not existent cast' }

      it 'response with valid status' do
        VCR.use_cassette(cast, record: :once) do
          expect(subject_class.status).to eql(200)
        end
      end

      it 'response with valid movie infos' do
        VCR.use_cassette(cast, record: :once) do
          expect(data).to be_nil
        end
      end
    end

    context 'call describe class with 500 error' do
      let(:value) { { query: -1 } }
      let(:cast) { '500_cast' }

      it 'response with valid status' do
        VCR.use_cassette(cast, record: :once) do
          expect(subject_class.status).to eql(500)
        end
      end
    end
  end
end
