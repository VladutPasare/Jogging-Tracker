module Api
  class JoggingEntriesController < BaseController
    before_action :require_api_token
    before_action :set_entry, only: [:show, :update, :destroy]

    # GET /api/jogging_entries
    def index
      entries = current_user.admin? ? JoggingEntry.all : current_user.jogging_entries

      if params[:from].present? && params[:to].present?
        entries = entries.where(date: params[:from]..params[:to])
      end

      render json: entries
    end

    def show
      render json: @entry
    end

    def create
      entry = current_user.jogging_entries.new(entry_params)
      if entry.save
        render json: entry, status: :created
      else
        render json: entry.errors, status: :unprocessable_entity
      end
    end

    def update
      unless current_user.admin? || @entry.user == current_user
        return render json: { error: "Forbidden" }, status: :forbidden
      end

      if @entry.update(entry_params)
        render json: @entry
      else
        render json: @entry.errors, status: :unprocessable_entity
      end
    end

    def destroy
      unless current_user.admin? || @entry.user == current_user
        return render json: { error: "Forbidden" }, status: :forbidden
      end

      @entry.destroy
      render json: { message: "Deleted" }
    end

    def weekly_report
      entries = current_user.admin? ? JoggingEntry.all : current_user.jogging_entries

      report = entries.group("strftime('%Y-%W', date)")
                      .select("strftime('%Y-%W', date) AS week, SUM(distance) AS total_distance, SUM(duration) AS total_duration")

      render json: report
    end

    private

    def set_entry
      @entry = JoggingEntry.find(params[:id])
    end

    def entry_params
      params.permit(:date, :distance, :duration)
    end
  end
end
