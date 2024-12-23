# frozen_string_literal: true

class RemoveTalks < ActiveRecord::Migration[8.0]
  def up
    drop_table :talks
  end

  def down
    create_table :talks do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.string :event_name, null: false
      t.date :presented_on, null: false
      t.text :description

      t.timestamps
    end
    add_index :talks, :presented_on, order: { presented_on: :desc }
  end
end
