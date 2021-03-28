# # == Schema Information
#
# Table name: genres
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  external_id   :integer
#
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe '.create' do
    it 'should create new genre record' do
      Genre.create(name: 'genre', external_id: 1)
      expect { Genre.create(name: 'genre', external_id: 1) }.to change { Genre.count }
    end

    %i[name external_id].each do |field|
      it { should validate_presence_of(field) }
    end
  end
end
