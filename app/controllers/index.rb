enable :sessions

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
end

get '/recipe/new' do
  erb :create_recipe
end

post '/recipe/create' do
  user = User.find(session[:id])

  recipe = Recipe.create(params[:recipe])
  puts recipe
  ingredient = Ingredient.create(params[:ingredient])
  puts ingredient.name
  recipe.ingredients << ingredient
  recipe.set_quantity_of(ingredient, params[:quantity], params[:quantity_description])

  user.recipes << recipe

  erb :index

end