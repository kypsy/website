class MessagesController < ApplicationController
  before_action :require_login
  before_action :find_user_by_username
  before_action :find_conversation

  def new
    @slug  = "messages"
    @title = "Messenger on Kypsy"

    if !@conversation.new_record?
      redirect_to conversation_path(@user.username)
    elsif !redirect_if_age_inappropriate(@user)
      @message = @conversation.messages.build(sender: current_user, recipient: @user)
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to conversations_path
  end

  def create
    message              = current_user.outbound_messages.build(messages_params)
    message.sender       = current_user
    message.recipient    = @user
    message.conversation = @conversation
    if message.save
      message.notify if message.needs_notify?
      redirect_to conversation_path(@user.username)
    elsif message.errors.has_key? :restricted
      redirect_to conversations_path, notice: message.errors[:restricted]
    else
      render :new
    end
  end

  private

  def find_conversation
    @conversation = current_user.conversations.with_user(@user).first || Conversation.new()
  end

  def messages_params
    params.require(:message).permit(:body)
  end
end
