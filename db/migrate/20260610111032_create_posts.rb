class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.text :content, limit: 140

      t.timestamps
    end
  end
end
