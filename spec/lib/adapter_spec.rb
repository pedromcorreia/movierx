# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Adapter::Adapter do
  describe '.new' do
    subject(:subject_class) { described_class.new(value) }
    context 'when params is valid' do
      let(:value) { { query: 'query', type: :movie, limit: 0, offset: 1 } }
      it 'response with valid array keys' do
        expect(subject_class.query).to eql(value[:query])
        expect(subject_class.limit).to eql(value[:limit])
        expect(subject_class.offset).to eql(value[:offset])
        expect(subject_class.type).to eql(value[:type])
      end
    end
  end

  describe '.call' do
    subject(:subject_class) do
      described_class.new(value).call
    end

    context 'call describe class with genre type' do
      let(:genre) { 'Action' }
      let(:value) { { query: genre, type: :genre, limit: 1, offset: 1 } }
      it 'response with valid array movies' do
        VCR.use_cassette(genre, record: :once) do
          expect { subject_class }.not_to raise_error(Exception)
        end
      end
    end

    context 'call describe class with movie type' do
      let(:value) { { query: 1724, type: :movie } }
      let(:title) { 'The Incredible Hulk' }
      it 'response with valid movie infos' do
        VCR.use_cassette(title, record: :once) do
          expect { subject_class }.not_to raise_error(Exception)
        end
      end
    end

    context 'call describe class with cast type' do
      let(:cast) { 'Edward Norton' }
      let(:value) { { query: 819, type: :cast } }
      it 'response with valid cast infos' do
        VCR.use_cassette(cast, record: :once) do
          expect { subject_class }.not_to raise_error(Exception)
        end
      end
    end

    context 'call describe class with invalid type' do
      let(:cast) { 'Edward Norton' }
      let(:value) { { query: 819, type: :not_existent } }
      it 'response with valid cast infos' do
        expect do
          subject_class
        end.to raise_error(Exception)
        expect do
          subject_class
        end.to raise_error('Unsuported genre')
      end
    end
  end
end
