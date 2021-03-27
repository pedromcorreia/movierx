# frozen_string_literal: true

class CreateGenres < ActiveRecord::Migration[6.0] # rubocop:todo Style/Documentation
  def change
    create_table :genres do |t|
      t.string :name
      t.integer :external_id

      t.timestamps
    end
  end
end
