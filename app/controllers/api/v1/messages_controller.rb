class Api::V1::MessagesController < ApplicationController
  require 'json'
  before_filter :authenticate

  api :GET, "/v1/users/:user_slug/messages", "Get all messages (sent and received) for current user."
  def index
    render :json => @current_user.messages, :status => :ok
  end

  api :POST, "/v1/users/:user_slug/messages", "Create a new message."
  param :message, Hash do
    param :sender_id, String, "The current user's slug.", :required => true
    param :receiver_id, String, "The receiving user's slug.", :required => true
    param :body, String, "The message body. Must contain at least one character.", :required => true
  end
  example Message.example
  def create
    @message = Message.new(message_params)

    if @message.save
      render :json => @message, :status => :ok
    else
      render :json => @message.errors, :status => :unprocessable_entity
    end
  end

  private
  def message_params
    params.require(:message).permit(:sender_id, :receiver_id, :body)
  end
end
