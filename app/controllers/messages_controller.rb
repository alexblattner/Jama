class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  include SessionsHelper
  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  def discussion
    @curruser = current_user
    @messages = Message.all
    @message = Message.new
    @topics = Topic.all
   
    @ratetopics = Topic.where(topictype: "Rate the game")
    @strategytopics = Topic.where(topictype: "Game strategy")
    @questiontopics = Topic.where(topictype: "Questions about the Game")
    
    render 'discussion'
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
    
    @message.user = current_user
    @message.save
    @topic_id = message_params[:topic_id]
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    Message.find(params[:id]).destroy
  	  respond_to do |format|
	    format.js { render "destroy", :locals => {:id => params[:id]} }
	  end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:body, :topic_id)
    end
end
