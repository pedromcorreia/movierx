# frozen_string_literal: true

file = File.read("#{Rails.root}/db/seeds/gender.json")

data_hash = JSON.parse(file)
data_hash.each do |data|
  Genre.create!({ name: data['name'], external_id: data['id'] })
end
