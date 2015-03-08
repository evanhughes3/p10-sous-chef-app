class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_ingredients
  has_many :ingredients, :through => :recipe_ingredients

  def get_quantity_of(ingredient_obj)
    self.recipe_ingredients.find_by(ingredient_id: ingredient_obj.id).quantity
  end

  def get_quantity_description_of(ingredient_obj)
    self.recipe_ingredients.find_by(ingredient_id: ingredient_obj.id).quantity_description
  end

  def set_quantity_of(ingredient_obj, after_change, qty_description)
      self.recipe_ingredients.find_by(ingredient_id: ingredient_obj.id).update(quantity: after_change, quantity_description: qty_description)
  end

end
