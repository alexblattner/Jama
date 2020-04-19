class SessionsController < ApplicationController
    # skip_before_action :require_login, only: [:new, :create]
    
  include SessionsHelper
  skip_before_action :require_login, only: [:new, :create]
  include SessionsHelper

  # GET /sessions
  # GET /sessions.json
  def index
    @sessions = Session.all
  end

  # GET /sessions/1
  # GET /sessions/1.json
  def show
  end

  # GET /sessions/new
  def new
  end

  # GET /sessions/1/edit
  def edit
  end

 


    def create
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
        log_in user
        redirect_to root_path
        # Log the user in and redirect to the user's show page.
      else
        # Create an error message.
        flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
        render 'new'
      end
    end
    # destroy the current session
    def destroy
      log_out
      redirect_to root_url
    end
  
  end
  