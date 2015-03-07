User.create(username: 'evan', password: '1', email: 'evan@evan.com', first_name: 'evan', last_name: 'hughes')

Recipe.create(name: 'apples and peanut butter', instructions: "smother PB all over an apple and enjoy!")

Ingredient.create(name: 'apple')
Ingredient.create(name: 'peanut butter')

RecipeIngredient.create(recipe_id: 1, ingredient_id: 1, quantity: 1)
RecipeIngredient.create(recipe_id: 1, ingredient_id: 2, quantity: 1, quantity_description: 'jar')