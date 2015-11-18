class Api::V1::MessagesController < ApplicationController
  before_filter :authenticate

  def index
    render :json => @current_user.messages, :status => :ok
  end

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
