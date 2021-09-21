class SessionsController < ApplicationController
    def new
        render :new
    end

    def create
        @user = User.find_by_credentials(params[:user][:email], params[:user][:password])
        if @user
            session[:session_token] = @user.reset_session_token!
            redirect_to user_url(@user)
        else
            flash[:errors] = ['Invalid Email and/or Password']
            redirect_to new_session_url
        end 
    end

    def destroy
        @user = User.find_by(session_token: session[:session_token])

        if @user
            @user.reset_session_token!
            session[:session_token] = nil
        end

        flash[:success] = ['Successfully logged out']
        redirect_to new_session_url
    end
end