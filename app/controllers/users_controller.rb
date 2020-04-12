class UsersController < ApplicationController
    
    get '/users' do
        if Helpers.is_logged_in?(session)
            @users = User.all
        else
            redirect '/'
        end
        erb :'users/index'
    end
    
    get '/signup' do
        if Helpers.is_logged_in?(session)
            user = Helpers.current_user(session)
            redirect to "/users/#{user.id}"
        end
        erb :'users/signup'
    end

    post '/signup' do
        user = User.create(params)
        if user.valid?
            session[:user_id] = user.id 
            redirect to "/users/#{user.id}"
        else 
            flash[:danger] = "Username/Email already registered. Please log in or try again!"
            erb :'users/signup'
        end
    end

    get '/users/:id' do
        if Helpers.is_logged_in?(session) && User.find_by(id: params[:id])
            @user = User.find_by(id: params[:id])
            @groceries = @user.groceries
        else
            redirect to '/login'
        end
        erb :'users/show'
    end


    get '/login' do
        if Helpers.is_logged_in?(session)
            user = Helpers.current_user(session)
            redirect to "/users/#{user.id}"
        end
        erb :'users/login'
    end
    
    post '/login' do 
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect to "/users/#{user.id}"
        else
            flash[:danger] = "Incorrect username/password. Please try again!"
            erb :'users/login'
        end
    end

    get '/logout' do
        if Helpers.is_logged_in?(session)
            session.clear 
            flash[:warning] = "Goodbye!"
            erb :'users/login'
        else
            redirect to '/login'
        end
    end

end