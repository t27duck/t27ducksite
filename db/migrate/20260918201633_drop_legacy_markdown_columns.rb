class DropLegacyMarkdownColumns < ActiveRecord::Migration[8.1]
  # The markdown these columns held was converted to Action Text by
  # MovePageContentToActionText and MovePostContentToActionText. They have been
  # unread since those shipped, and this drop is the point of no return for them:
  # rolling back restores the columns but not their contents.
  def up
    remove_column :pages, :content
    remove_column :posts, :content
  end

  def down
    add_column :pages, :content, :text
    add_column :posts, :content, :text
  end
end
