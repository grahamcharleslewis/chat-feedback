class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show ]

  def index
    @chats = Chat.all
  end

  def show
  end

  def new
    @chat = Chat.new(uuid: SecureRandom.uuid)
  end

  def create
    @chat = Chat.new(chat_params)

    if @chat.save
      redirect_to chat_url(@chat), notice: "Chat was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_chat
      @chat = Chat.find(params[:id])
    end

    def chat_params
      params.require(:chat).permit(:uuid, :prompt, :reply)
    end
end
