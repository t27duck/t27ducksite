class RenameProjectsUrlToRepoUrl < ActiveRecord::Migration[8.1]
  def change
    rename_column :projects, :url, :repo_url
    change_column_null :projects, :repo_url, true
  end
end
