class AddMiniToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :mini, :boolean, default: false
  end
end
