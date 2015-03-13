require 'spec_helper'
enable :sessions

describe 'POST /' do
  include Rack::Test::Methods

  before do
    User.delete_all
    Recipe.delete_all
    Ingredient.delete_all
  end

  before(:each) do
    evan = User.create(
      id: 1,
      username: "evan",
      password: "lala",
      email: "evanhughes3@gmail.com",
      phone_number: "15101001234",
      first_name: "Evan",
      last_name: "Hughes"
      )
    tomatoes = Ingredient.create(
      name: "4 fresh tomatoes"
      )
    bread = Ingredient.create(
      name: "1 loaf of bread"
      )
    recipe = Recipe.create(
      name: "Pasta and tomatoes",
      instructions: "Put tomatoes on some bread and enjoy!"
      )
    recipe.ingredients << tomatoes
    recipe.ingredients << bread
    evan.recipes << recipe
    session[:id] = 1
  end

  context "recipe/create" do
    it "creates a new recipe" do

      params = {
        name: "Bread and cheese",
        instructions: "Put cheese on some bread",
        ingredients: ["Cheese", "Bread"],
      }
      post '/recipe/create', params

      expect{last_response}.to change{Recipe.count}.by(1)
    end
  end

end




#   context "when a user is not logged in" do
#     it "displays all widgets" do
#       widget = Widget.create(title: 'motorcycle', content: 'something that goes fast')
#       widget = Widget.create(title: 'car', content: 'something that goes even faster')
#       get '/widgets'
#       expect(last_response.body).to include("<li>motorcycle</li>")
#       expect(last_response.body).to include("<li>car</li>")

#     end
#   end

#   context "when a user is logged in" do
#     it "displays all of the given user's widgets" do
#       user = User.create(username: "Evan", password: "123")
#       params = {username: "Evan", password: "123" }
#       session = {'rack.session' => {user_id: 1} }
#       widget = Widget.create(user_id: 1, title: 'air wheel', content: 'something that goes without hands')
#       get '/widgets', params, session
#       expect(last_response.body).to include("<li>air wheel</li>")
#     end

#     it "does not display other users' widgets" do
#       user1 = User.create(username: "Ben", password: "456")
#       params = {username: "Ben", password: "456" }
#       session = {'rack.session' => {user_id: 2} }
#       widget = Widget.create(user_id: 2, title: 'tesla', content: 'requires no gas')

#       user = User.create(username: "Evan", password: "123")
#       params = {username: "Evan", password: "123" }
#       session = {'rack.session' => {user_id: 1} }
#       widget = Widget.create(user_id: 1, title: 'air wheel', content: 'something that goes without hands')
#       get '/widgets', params, session
#       expect(last_response.body).to include("<li>air wheel</li>")
#       expect(last_response.body).not_to include("<li>tesla</li>")

#     end
#   end
# end