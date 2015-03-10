helpers do

  def current_user
        # TODO: return the current user if there is a user signed in.
        if session[:id]
          User.find(session[:id])
        end
  end

  def client_env
    {
      'APP_ID'  => ENV['APP_ID'],
      'APP_KEY' => ENV['APP_KEY'],
    }
  end

end