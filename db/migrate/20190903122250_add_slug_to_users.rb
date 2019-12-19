class AddSlugToUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :slug, unique: true
    User.find_each(&:save)
  end
end
