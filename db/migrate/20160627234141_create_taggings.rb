class CreateTaggings < ActiveRecord::Migration[5.0]
  def change
    create_table :taggings do |t|
      t.belongs_to :post, foreign_key: true, null: false
      t.belongs_to :tag, foreign_key: true, null: false

      t.timestamps
    end
  end
end
