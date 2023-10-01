require "faker"
require "csv"

class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show ]

  def index
    @chats = Chat.all

    respond_to do |format|
      format.html
      format.csv do
        response.headers["Content-Type"] = "text/csv"
        response.headers["Content-Disposition"] = "attachment; filename=chat.csv"
      end
    end
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
    @chat.reply = Faker::Company.bs

    if @chat.save
      redirect_to new_chat_url(uuid: @chat.uuid), notice: "Chat created."
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
