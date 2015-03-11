class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :instructions
      t.string :img_url
      t.string :recipe_url
      t.belongs_to :user
      t.string :yummly_id

      t.timestamps
    end
  end
end
