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
      User.find_by_id(session[:user_id])
    end
  end

  get '/signup' do
    erb :"/users/new"
  end

  get '/login' do
    if logged_in?
      redirect "/medications"
    else
    erb :"/users/login"
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/medications'
    else
      redirect "/login"
    end
  end

  get '/logout' do
    session.clear
    redirect "/"
  end

  get '/medications' do 
    if session[:user_id]
      @user = current_user
      @medications = @user.medications
      @medications.each do |medication|
        puts medication.medication_name
      end
      erb :"medications/medications"
    else
      redirect "/users/new"
    end
  end 

  get '/medications/new' do
    if logged_in?
      erb :"medications/new"
    else
      redirect "/login"
    end
  end

  post '/medications' do 
    @user = current_user
    @medication = @user.medications.build(params)
    if @medication.save
      redirect "/medications"
    else
      redirect "/medications/new"
    end
  end

  get '/medications/:id' do
    @medication = Medication.find(params[:id])
    erb :"/medications/show"
  end
  

  # post '/medications' do
  #   if !params[:medication_name].empty?
  #     binding.pry
  #     @medication = Medication.create(medication_name: params[:medication_name])
  #   else
  #     redirect "/medications/new"
  #   end
  # end

  # get '/users/new' do
  #     erb :"users/new"
  # end

  

  # get '/medications' do
  # @medications = Medication.all 
  #   if logged_in?
  #     erb :"medications/medications"
  #   else
  #     redirect "/login"
  #   end
  # end

  # get '/medications/new' do
  #   if logged_in?
  #     erb :"medications/new"
  #   else
  #     redirect "/login"
  #   end
  # end

  get '/medications/:id' do
    @medication = Medication.find(params[:id])
    if @medication
      erb :"/medications/show"
    else
      redirect "/login"
    end
  end

  get '/medications/:id/edit' do
      @medication = Medication.find(params[:id])
      erb :"/medications/edit"
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

  

  # post '/medications' do
  #   if !params[:medication_name].empty?
  #     @medication = Medication.create(medication_name: params[:medication_name])
  #   else
  #     redirect "/medications/new"
  #   end
  # end

  patch '/medications/:id' do
    @medication = Medication.find(params[:id])
    puts params 
    if @medication.update(params["medication"])
      redirect "/medications/#{@medication.id}"
    else
      redirect "/medications#{medication.id}/edit"
    end
  end 

  delete '/medications/:id' do
      # @medication = Medication.find(params[:id])
      # if logged_in? && @medication.user_id == current_user
      #   @medication.destroy
      #   redirect "/medications"
      # else
      #   redirect "/login"
      # end
      Medication.destroy(params[:id])
      redirect "/medications"
  end

end
