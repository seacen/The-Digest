class RemoveWebsiteFromSource < ActiveRecord::Migration
  def change
    remove_column :sources, :website, :string
  end
end
