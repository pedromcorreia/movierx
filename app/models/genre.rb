# frozen_string_literal: true

class Genre < ApplicationRecord
  validates :name, presence: true
  validates :external_id, presence: true
end
