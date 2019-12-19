class AddArticlesCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :articles_count, :integer, default: 0
  end
end
