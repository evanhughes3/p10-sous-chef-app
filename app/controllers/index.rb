use Rack::Flash

get '/' do
  @message = flash[:notice]
  erb :index
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.where(username: params[:username]).first

  if user && user.authenticate(params[:password])
    session[:id] = user.id
    redirect '/'
  else
    flash[:notice] = "username and password did not match"
    @message = flash[:notice]
    erb :login
  end
end

get '/signup' do
  erb :signup
end

post '/signup' do
  user = User.new(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], username: params[:username], phone_number: params[:phone_number], password: params[:password])

  if user.save
    session[:id] = user.id
    redirect '/'
  else
    flash[:notice] = "There was an error with your signup"
    @message = flash[:notice]
    erb :signup
  end
end

delete '/signout/:id' do
  # sign-out -- invoked
  session[:id] = nil
  @message = flash[:notice] = "You have been successfully signed out"
  redirect '/'
end

get '/recipe/new' do
  erb :create_recipe
end

post '/recipe/create' do
  user = User.find(session[:id])

  recipe = Recipe.create(name: params[:recipe_name], instructions: params[:instructions])

  params[:ingredient].each do |ingredient|
    recipe.ingredients << Ingredient.create(name: ingredient)
  end

  user.recipes << recipe

  flash[:notice] = "You created a new recipe: #{recipe.name}"
end

get '/recipe/search' do
  erb :search
end

get '/recipe/search/:id' do
  recipe = Yummly.find(params[:id])

  erb :recipe_page, :locals => {:recipe => recipe}
end

get '/recipe/display/:id' do
  recipe = Recipe.find(params[:id])
  p recipe

  erb :your_recipe_page, :locals => {:recipe => recipe}
end

post '/recipe/:id/delete' do
  recipe = Recipe.find(params[:id])
  recipe.destroy

  flash[:notice] = "#{recipe.name} has been removed"
  @message = flash[:notice]

  redirect '/'
end

get '/searchResults/:keywords' do # => TODO
  keywords = params[:keywords].split(" ").join("+")
  url = "http://api.yummly.com/v1/api/recipes?_app_id=#{ENV['APP_ID']}&_app_key=#{ENV['APP_KEY']}&q=#{keywords}&requirePictures=true&maxResult=100&start=10";
  response = HTTParty.get(url)

  unless response['matches'].length == 0
    response.parsed_response['matches'].to_json
  end
end

get '/add/form/ingredient' do
  ingredient = params[:ingredient_name]
  p params[:ingredient_name]

  erb :_create_ingredient_form, layout: false, :locals => {ingredient: ingredient}
end

post '/user/:id/recipe/:recipe_id/save' do
  user = User.find(params[:id])
  recipe = Yummly.find(params[:recipe_id])
  recipe_name = recipe.name
  img_url = recipe.images[0].large_url
  recipe_url = recipe.json['source']['sourceRecipeUrl']
  yummly_id = recipe.json['id']

  your_recipe = Recipe.create(name: recipe_name, img_url: img_url, recipe_url: recipe_url, yummly_id: yummly_id)


  recipe.json["ingredientLines"].each do |ingredient|
    your_recipe.ingredients << Ingredient.create(name: ingredient)
  end

  user.recipes << your_recipe

  flash[:notice] = "#{recipe.name} has been added to the list!"
  @message = flash[:notice]

  redirect '/'

end

delete '/users/:id/list/delete' do
  user = User.find(params[:id])
  user.recipes.destroy_all

  flash[:notice] = "Your shopping list has been cleared!"
  @message = flash[:notice]

  redirect '/'
end

post "/users/:id/list/send" do
  user = User.find(params[:id])
  phone_number = user.phone_number
  all_ingredients = []
  current_user.recipes.each {|recipe| recipe.ingredients.each {|ingredient| all_ingredients << ingredient.name}}
  ingredient_list = all_ingredients.join(", ")

  @client = Twilio::REST::Client.new(ENV['TWILIO_ACOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  @client.account.messages.create({
    :from => '+14154296667',
    :to => phone_number,
    :body => ingredient_list,
  })

  flash[:notice] = "Your list has been sent to your phone!"

  @message = flash[:notice]

  redirect '/'
end



# recipe = Recipe.create(params[:recipe])
#   ingredient = Ingredient.create(params[:ingredient])
#   puts ingredient.name
#   recipe.ingredients << ingredient
#   recipe.set_quantity_of(ingredient, params[:quantity], params[:quantity_description])
#   user.recipes << recipe
#   erb :index

# get 'http://api.yummly.com/v1/api/recipe/Mediterranean-Salad-603851?_app_id=b68a708c&_app_key=c990231d1ec74289fff36220ae4ba6fb' do


# end

# get ''http://api.yummly.com/v1/api/ do
#   recipes?_app_id=b68a708c&_app_key=c990231d1ec74289fff36220ae4ba6fb&recipes?q=salad

# end
# http://api.yummly.com/v1/api/recipes?_app_id=b68a708c&_app_key=c990231d1ec74289fff36220ae4ba6fb&recipes?q=salad
