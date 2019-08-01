class RemoveTitleFromArticles < ActiveRecord::Migration[5.1]
  def change
    remove_column :articles, :title, :string
  end
end
