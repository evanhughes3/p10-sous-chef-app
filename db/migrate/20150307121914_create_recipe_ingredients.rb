class CreateRecipeIngredients < ActiveRecord::Migration
  def change
    create_table :recipe_ingredients do |t|
      t.belongs_to :recipe
      t.belongs_to :ingredient
      t.integer :quantity
      t.string :quantity_description

      t.timestamps
  end
  end
end
