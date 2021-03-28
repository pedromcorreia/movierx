# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Adapter::MovieInfo do
  describe '.new' do
    subject(:subject_class) { described_class.new(value) }
    context 'when params is valid' do
      let(:value) { { genre: 'Action', limit: 0, offset: 1 } }
      it 'response with valid array keys' do
        expect(subject_class.genre).to eql(value[:genre])
        expect(subject_class.limit).to eql(value[:limit])
        expect(subject_class.offset).to eql(value[:offset])
      end
    end
  end

  describe '.call' do
    subject(:subject_class) { described_class.new(value).call }
    context 'call describe class returns valid response with valid params' do
      let(:genre) { 'Action' }
      let(:value) { { genre: genre, limit: 10, offset: 1 } }
      it 'response with valid array movies' do
        VCR.use_cassette('Full_response', record: :once) do
          expect(subject_class.keys).to match_array(%i[infos errors])
        end
      end

      it 'response with errors' do
        VCR.use_cassette('Full_response', record: :once) do
          subject_class[:errors].each do |error|
            expect(error[:errorCode]).to eql(440).or eql(450)
          end
          expect(subject_class[:errors].count).to eql(34)
        end
      end

      it 'response with infos' do
        VCR.use_cassette('Full_response', record: :once) do
          errors = subject_class[:errors].select { |e| e[:errorCode] == 450 }.count
          expect(subject_class[:infos].count).to eql(value[:limit] - errors)
          expect(subject_class[:infos].first.keys).to match_array(%i[id title releaseYear revenue posterPath
                                                                     genres cast])
        end
      end
    end

    context 'call describe class returns invalid response with invalid params' do
      let(:genre) { 'Action' }
      let(:value) { { genre: genre, limit: 1, offset: 1 } }
      it 'response with valid array movies' do
        VCR.use_cassette('Full_response_errors', record: :once) do
          expect(subject_class.keys).to match_array(%i[infos errors])
          expect(subject_class).to eql({ infos: [], errors: [] })
        end
      end
    end
  end
end
