# frozen_string_literal: true

class AddKindToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :kind, :string

    Post.update_all(kind: "post")

    change_column_null :posts, :kind, false
  end
end
