require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :welcome
  end

  helpers do
    def logger_in?
      !!session[user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

  get '/signup' do
    if !!logged_in?
      erb :'users/new'
    else
      redirect "/medications"
    end
  end

  get '/login' do
    if logged_in?
        redirect "/medications"
    else
      erb :'users/login'
  end

  get '/logout' do
    session.clear
    redirect "/"
  end

  get '/medications' do
    if Helpers.is_logged_in?(session)
end
