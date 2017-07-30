class ConversationsController < ApplicationController
  before_action :require_login
  before_action :find_conversation, only: [:show, :destroy]

  def index
    @title = t("titles.inbox")
    @slug  = "inbox"
    @conversations = current_user.conversations.not_deleted(current_user).distinct
  end

  def show
    if @conversation.messages.any? { |msg| msg.unread && msg.recipient_id == current_user.id}
      @conversation.messages.where(recipient_id: current_user.id).update_all(unread: false)
    end

    @slug     = "messages"
    @title    = t("titles.conversation", username: @conversation.counterpart(current_user).username, brand: t(:brand))
    @messages = @conversation.messages.order('created_at asc')
    @message  = current_user.outbound_messages.build(recipient_id: @user.id, conversation_id: @conversation.id)
  end

  def destroy
    @conversation.delete_from_user(current_user)
    redirect_to conversations_path, notice: t("inbox.conversation_deleted")
  end

  private

  def find_conversation
    find_user_by_username
    @conversation = current_user.conversations.with_user(@user).first
    if @conversation.nil?
      redirect_to root_path
    end
  end
end
