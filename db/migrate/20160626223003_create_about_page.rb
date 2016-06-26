class CreateAboutPage < ActiveRecord::Migration[5.0]
  def up
    page = Page.find_or_initialize_by(slug: 'about')
    page.content = 'Coming soon!' if page.content.blank?
    page.save!
  end

  def down
    page = Page.find_by(slug: 'about')
    page.destroy! if page
  end
end
