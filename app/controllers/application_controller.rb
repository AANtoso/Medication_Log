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
  end

  post '/users' do
      @user = User.new(params)
      if @user.save
        session[:user_id] = @user.id
        redirect "/medications"
      # else 
      #   redirect "/signup"
      end
  end 

  get '/login' do
    erb :"/users/login"
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
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
      erb :"medications/new"
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
    @medication = @user.medication.create(params)
    if @blog.save
      redirect "/medications"
    else
      redirect "/medications/new"
    end
  end

  # post '/medications' do
  #   if !params[:medication_name].empty?
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
      erb :"/medications/medication"
    else
      redirect "/login"
    end
  end

  get '/medications/:id/edit' do
      @medication = Medication.find(params[:id])
      erb :"/medications/edit"
  end

  # post '/signup' do
  # @user = User.new(params)
  #   if @user.save # && !params[:username].empty? && !params[:email].empty?
  #   session[:user_id] = @user.id
  #   redirect "/medications"
  #   else
  #     redirect "/users/new"
  #   end
  # end

  

  # post '/medications' do
  #   if !params[:medication_name].empty?
  #     @medication = Medication.create(medication_name: params[:medication_name])
  #   else
  #     redirect "/medications/new"
  #   end
  # end

  patch '/medications/:id' do
    @medication = Medication.find(params[:id])
    if @medication.update(medication_name: params[:medication_name])
      # , params[:class], params[:indication], params[:dose], params[:frequency], params[:instructions])
      redirect "/medications/#{@medication.id}"
    else
      redirect "/medications#{medication.id}/edit"
    end
  end 

  delete 'medications/:id/delete' do
      Medication.destroy(params[:id])
      redirect "/medications"
  end

end
