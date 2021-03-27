class CreateMovieInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :movie_infos do |t|

      t.timestamps
    end
  end
end
