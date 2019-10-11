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
end

  get '/logout' do
    session.clear
    redirect "/"
  end

  get '/medications' do
  @medications = Medication.all 
    if logged_in?
      erb :"medications/medications"
    else
      redirect "/login"
    end
  end

  get '/medications/new' do
    if logged_in?
      erb :'medications/new'
    else
      redirect "/login"
    end
  end

  get '/medications/:id' do
    @medication = Medication.find(params[:id])
    if logged_in?
      erb :"/medications/medication"
    else
      redirect "/login"
    end
  end

  get '/medications/:id/edit' do
    if logged_in?
      @medication = Medication.find(params[:id])
    if @medication.used_id == current_user.id
      erb '/medications/edit'
    else
      redirect "/medications"
    end
  end
end

post 'signup' do
  @user = User.new(params)
  if @user.save && !params[:username].empty? && !params[:email].empty?
    @user.save
    session[:user_id] = @user.id
    redirect '/medications'
  else
    redirect '/signup'
  end
end




end
