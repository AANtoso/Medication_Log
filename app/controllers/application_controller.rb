require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get "/" do
    erb :welcome
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

  get '/signup' do
    erb :"/users/new"
    # if !!logged_in?
    #   erb :"users/new"
    # else
    #   redirect "/"
    # end
  end

  get '/login' do
    erb :"/users/login"
  #   if logged_in?
  #       redirect "/medications"
  #   else
  #     erb :"users/new"
  # end
end

  get '/logout' do
    session.clear
    redirect "/"
  end

  get '/users/new' do
      erb :"users/new"
  end

  get '/medications' do 
    if logged_in?
      @user = current_user
      @medications = @user.medications
      erb :"medications/new"
    else
      redirect "/users/new"
    end
  end 

  # get '/medications' do
  # @medications = Medication.all 
  #   if logged_in?
  #     erb :"medications/medications"
  #   else
  #     redirect "/login"
  #   end
  # end

  get '/medications/new' do
    if logged_in?
      erb :"medications/new"
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
      erb :"/medications/edit"
    else
      redirect "/medications"
    end
  end
end

  post '/signup' do
  @user = User.new(params)
    if @user.save # && !params[:username].empty? && !params[:email].empty?
    session[:user_id] = @user.id
    redirect "/medications"
    else
      redirect "/users/new"
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/medications'
    else
      redirect "/signup"
    end
  end

  post '/medications' do
    if !params[:medication_name].empty?
      @medication = Medication.create(medication_name: params[:medication_name])
    else
      redirect "/medications/new"
    end
  end

  patch '/medications/:id' do
    @medication = Medication.find(params[:id])
    @medication.update(medication_name: params[:medication_name])
    if !@medication.medication_name.empty?
      redirect "/medications/#{@medication.id}"
    else
      redirect "/medications#{medication.id}/edit"
    end
  end 

  delete 'medications/:id/delete' do
    @medication = Medication.find(params[:id])
    if logged_in? && @medication.user_id == current_user.id
      @medication.destroy
      redirect "/medications"
    else
      redirect "/login"
    end
  end

end
