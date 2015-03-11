get '/' do
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
    @error = "username and password did not match"
    erb :login
  end
end

get '/signup' do
  erb :signup
end

post '/signup' do
  user = User.new(first_name: params[:first_name], last_name: params[:last_name], email: params[:email], username: params[:username], password: params[:password])

  if user.save
    session[:id] = user.id
    redirect '/'
  else
    @error = "There was an error"
    erb :signup
  end
end

delete '/signout/:id' do
  # sign-out -- invoked
  session[:id] = nil
  @sign_out_message = "You have been successfully signed out"
  redirect '/'
end

get '/recipe/new' do
  erb :create_recipe
end

post '/recipe/create' do

  user = User.find(session[:id])

  recipe = Recipe.create(params[:recipe])

  ingredient = Ingredient.create(name: params[:ingredient_name])

  recipe.ingredients << ingredient

  user.recipes << recipe

  redirect "/"

end

get '/recipe/search' do
  erb :search
end

get '/recipe/:id' do
  recipe = Yummly.find(params[:id])
  erb :recipe_page, layout: false, :locals => {:recipe => recipe}
end

get '/searchResults/:keywords' do
  keywords = params[:keywords]
  url = "http://api.yummly.com/v1/api/recipes?_app_id=#{ENV['APP_ID']}&_app_key=#{ENV['APP_KEY']}&q=#{keywords}&requirePictures=true&maxResult=100&start=10";
  response = HTTParty.get(url)

  response.parsed_response['matches'].to_json
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

  @message = "#{recipe.name} has been added to the grocery list!s"
  # flash[:messages] =
  redirect '/'

end

post "/users/:id/list/send" do
  user = User.find(params[:id])
  phone_number = "+15104093210" #user.phone_number
  all_ingredients = []
  current_user.recipes.each {|recipe| recipe.ingredients.each {|ingredient| all_ingredients << ingredient.name}}
  ingredient_list = all_ingredients.join(", ")
  account_sid = 'AC52d17fccd30eb3cbd13c7397c0c29cd8'
  auth_token = '142371aa2abd7cbaddfedcdc619097f5'

  @client = Twilio::REST::Client.new(account_sid, auth_token)
  @client.account.messages.create({
    :from => '+14154296667',
    :to => phone_number,
    :body => ingredient_list,
    })
  @message = "Your list has been sent to your phone!"

  redirect "/"

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
