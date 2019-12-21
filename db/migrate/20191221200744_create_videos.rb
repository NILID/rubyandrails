class CreateVideos < ActiveRecord::Migration[5.2]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :url
      t.references :user, index: true, foreign_key: true
      t.integer :views, default: 0

      t.timestamps null: false
    end
  end
end
