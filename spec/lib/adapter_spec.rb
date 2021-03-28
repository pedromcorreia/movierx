# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Adapter::Adapter do
  describe '.currency_to_cents' do
    subject(:new_class) { described_class.new(value) }

    context 'when params is invalid' do
      let(:value) { { query: 'query', type: :movie, limit: 0,  offset: 1 } }
      it 'converts an integer amount into cents' do
        expect(new_class).to eql(BigDecimal.new('1000000.12345678'))
      end
    end
  end
end
