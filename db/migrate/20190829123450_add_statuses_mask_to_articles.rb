class AddStatusesMaskToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :statuses_mask, :integer, default: '1'
  end
end
