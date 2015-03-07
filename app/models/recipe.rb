class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :recipe_ingredients
  has_many :ingredients, :through => :recipe_ingredients

  #   def proficiency_for(skill_obj)
  #   self.recipe_ingredients.find_by(ingredient_id: skill_obj.id).proficiency
  # end

  def set_quantity_of(ingredient_obj, after_change, quantity_description)
      self.recipe_ingredients.find_by(ingredient_id: ingredient_obj.id).update(quanity: after_change)
  end

end
