class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.text :url
      t.string :title, default: nil
      t.references :urlable, polymorphic: true

      t.timestamps
    end
  end
end
