class RemoveUrlFromSource < ActiveRecord::Migration
  def change
    remove_column :sources, :url, :string
  end
end
