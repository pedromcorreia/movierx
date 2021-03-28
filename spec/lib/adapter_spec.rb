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

  describe '.call with genre type' do
    subject(:subject_class) do
      described_class.new(value).call
    end

    context 'call describe class with genre type' do
      let(:genre) { 'Action' }
      let(:value) { { query: genre, type: :genre, limit: 1, offset: 1 } }
      it 'response with valid array movies' do
        VCR.use_cassette(genre, record: :once) do
          expect(subject_class).to eql([1724])
        end
      end
    end

    context 'call describe class with inexisten genre' do
      let(:genre) { 'Not existent genre' }
      let(:value) { { query: genre, type: :genre, limit: 1, offset: 1 } }
      it 'response with valid empty array movies' do
        VCR.use_cassette(genre, record: :once) do
          expect(subject_class).to be_nil
        end
      end
    end
  end

  describe '.call with movie type' do
    subject(:subject_class) do
      described_class.new(value).call
    end

    context 'call describe class with movie type' do
      let(:value) { { query: 1724, type: :movie } }
      let(:title) { 'The Incredible Hulk' }
      it 'response with valid movie infos' do
        VCR.use_cassette(title, record: :once) do
          expect(subject_class.first.keys)
            .to eq(%w[id title tagline overview popularity runtime releaseDate revenue
                      budget posterPath originalLanguage genres cast])
          expect(subject_class.first['id']).to eq(value[:query])
          expect(subject_class.first['title']).to eq(title)
          expect(subject_class.first['genres']).to eq([878, 28, 12])
          expect(subject_class.first['cast']).to eq([819, 882, 3129, 227, 1462, 15_232, 68_277])
        end
      end

      context 'call describe class with inexisten cast' do
        let(:value) { { query: -1, type: :movie } }
        let(:title) { 'Not existent movie' }
        it 'response with valid empty array movies' do
          VCR.use_cassette(title, record: :once) do
            expect(subject_class).to be_empty
          end
        end
      end
    end
  end

  describe '.call with movie type' do
    subject(:subject_class) do
      described_class.new(value).call
    end

    context 'call describe class with cast type' do
      let(:cast) { 'Edward Norton' }
      let(:value) { { query: 819, type: :cast } }
      it 'response with valid cast infos' do
        VCR.use_cassette(cast, record: :once) do
          expect(subject_class.first.keys).to eql(%w[id name profilePath gender movies])
          expect(subject_class.first['name']).to eql(cast)
        end
      end
    end

    context 'call describe class with inexisten cast' do
      let(:cast) { 'Not existent cast' }
      let(:value) { { query: -1, type: :cast } }
      it 'response with valid empty array movies' do
        VCR.use_cassette(cast, record: :once) do
          expect(subject_class).to be_empty
        end
      end
    end
  end
end
