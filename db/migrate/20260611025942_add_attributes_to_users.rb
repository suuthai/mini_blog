class AddAttributesToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string, null: false, limit: 20
    add_column :users, :profile_text, :text, limit: 200
    add_column :users, :blog_url, :string

    add_index :users, :name, unique: true
  end
end
