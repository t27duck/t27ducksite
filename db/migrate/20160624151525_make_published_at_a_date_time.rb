class MakePublishedAtADateTime < ActiveRecord::Migration[5.0]
  def up
    remove_column :posts, :published_at
    add_column :posts, :published_at, :datetime
  end

  def down
    remove_column :posts, :published_at
    add_column :posts, :published_at, :string
  end
end
