class ConvertProjectDescriptionsToHtml < ActiveRecord::Migration[8.1]
  class MigrationProject < ActiveRecord::Base
    self.table_name = "projects"
  end

  def up
    change_column :projects, :description, :text, null: false

    MigrationProject.reset_column_information

    MigrationProject.find_each do |project|
      next if project.description.blank?

      html = Commonmarker.to_html(
        project.description.to_s.dup.force_encoding("utf-8"),
        options: { extension: { tagfilter: false }, render: { unsafe: true } }
      ).strip

      project.update_columns(description: html)
    end
  end

  def down
    change_column :projects, :description, :string, null: false
  end
end
