class JoggingEntriesController < ApplicationController
  before_action :require_login
  before_action :block_manager
  before_action :set_jogging_entry, only: %i[show edit update destroy]

  # GET /jogging_entries
  def index
    @jogging_entries =
      if current_user.admin?
        JoggingEntry.all
      else
        current_user.jogging_entries
      end

    if params[:from].present? && params[:to].present?
      @jogging_entries = @jogging_entries.where(date: params[:from]..params[:to])
    end
  end

  # GET /jogging_entries/:id
  def show
  end

  # GET /jogging_entries/new
  def new
    @jogging_entry = current_user.jogging_entries.new
  end

  # POST /jogging_entries
  def create
    @jogging_entry = current_user.jogging_entries.new(jogging_entry_params)

    if @jogging_entry.save
      redirect_to jogging_entries_path, notice: "Alergare adăugată!"
    else
      render :new
    end
  end

  # GET /jogging_entries/:id/edit
  def edit
  end

  # PATCH/PUT /jogging_entries/:id
  def update
    if @jogging_entry.update(jogging_entry_params)
      redirect_to jogging_entries_path, notice: "Alergare actualizată!"
    else
      render :edit
    end
  end

  # DELETE /jogging_entries/:id
  def destroy
    @jogging_entry.destroy
    redirect_to jogging_entries_path, notice: "Alergare ștearsă!"
  end

  # ==========================================
  #    HTML WEEKLY REPORT (PENTRU BROWSER)
  # ==========================================
  def weekly_report
    # Admin → toate alergările
    # User → doar alergările lui
    entries = current_user.admin? ? JoggingEntry.all : current_user.jogging_entries

    @reports = entries
      .group("strftime('%Y-%W', date)")
      .select("
        strftime('%Y-%W', date) AS week,
        SUM(distance) AS total_distance,
        SUM(duration) AS total_duration
      ")
  end

  private

  # Managerul nu are voie să acceseze alergările
  def block_manager
    if current_user.manager?
      redirect_to root_path, alert: "Managerul nu gestionează alergări"
    end
  end

  def set_jogging_entry
    @jogging_entry = JoggingEntry.find(params[:id])

    unless current_user.admin? || @jogging_entry.user == current_user
      redirect_to jogging_entries_path, alert: "Acces interzis"
    end
  end

  def jogging_entry_params
    params.require(:jogging_entry).permit(:date, :distance, :duration)
  end
end
