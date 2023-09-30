class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show ]

  def index
    @chats = Chat.all
  end

  def show
  end

  def new
    if params[:uuid]
      @chat = Chat.new(uuid: params[:uuid])
      @chats = Chat.where(uuid: params[:uuid])
    else
      @chat = Chat.new(uuid: SecureRandom.uuid)
      @chats = []
    end
  end

  def create
    @chat = Chat.new(chat_params)

    if @chat.save
      redirect_to chat_url(@chat), notice: "Chat created."
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
