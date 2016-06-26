class AddTitleToPages < ActiveRecord::Migration[5.0]
  def up
    add_column :pages, :title, :string
    Page.all.each do |page|
      page.title = page.slug.titlecase
      page.save!
    end
    change_column :pages, :title, :string, null: false
  end

  def down
    remove_column :pages, :title
  end
end
