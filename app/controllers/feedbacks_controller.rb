class FeedbacksController < ApplicationController
  before_action :set_feedback, only: %i[ show ]

  def index
    @feedbacks = Feedback.all
  end

  def show
  end

  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      redirect_to feedback_url(@feedback), notice: "Feedback was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def set_feedback
      @feedback = Feedback.find(params[:id])
    end

    def feedback_params
      params.require(:feedback).permit(:chat_id, :uuid, :version, :type, :response)
    end
end
