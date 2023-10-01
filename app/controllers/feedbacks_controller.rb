class FeedbacksController < ApplicationController
  before_action :set_feedback, only: %i[ show ]

  def index
    @feedbacks = Feedback.all
  end

  def show
  end

  def new
    # @feedback = Feedback.new(chat: params[:chat])

    @feedback = Feedback.new(
      level: "conversation", 
      uuid: params[:uuid],
      version: ENV["CONVERSATION_FEEDBACK_VERSION"])
  end

  def create
    @feedback = Feedback.new(feedback_params)
    @feedback.response = Feedback.create_response(params)

    if @feedback.save
      redirect_to new_chat_url(uuid: @feedback.uuid), notice: "Feedback created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    def feedback_params
      params.require(:feedback).permit(:chat_id, :uuid, :version, :level, :response)
    end
end
