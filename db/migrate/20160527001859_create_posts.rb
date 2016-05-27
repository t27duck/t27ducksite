class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.string :published_at

      t.timestamps
    end
  end
end
