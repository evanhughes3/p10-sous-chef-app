helpers do

  def current_user
        if session[:id]
          User.find(session[:id])
        end
  end

  # def client_env
  #   {
  #     'APP_ID'  => ENV['APP_ID'],
  #     'APP_KEY' => ENV['APP_KEY'],
  #   }
  # end

end