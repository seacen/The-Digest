class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.references :source, index: true, foreign_key: true
      t.string :title
      t.date :date_of_publication
      t.text :summary
      t.references :author, index: true, foreign_key: true
      t.string :image
      t.string :link

      t.timestamps null: false
    end
  end
end
