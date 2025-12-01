class JoggingEntriesController < ApplicationController
  before_action :require_login
  before_action :block_manager
  before_action :set_jogging_entry, only: %i[show edit update destroy]

  def index
    if current_user.admin?
      @jogging_entries = JoggingEntry.all
    else
      @jogging_entries = current_user.jogging_entries
    end

    if params[:from].present? && params[:to].present?
      @jogging_entries = @jogging_entries.where(date: params[:from]..params[:to])
    end
  end

  def show; end

  def new
    @jogging_entry = current_user.jogging_entries.new
  end

  def create
    @jogging_entry = current_user.jogging_entries.new(jogging_entry_params)

    if @jogging_entry.save
      redirect_to jogging_entries_path, notice: "Alergare adăugată!"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @jogging_entry.update(jogging_entry_params)
      redirect_to jogging_entries_path, notice: "Alergare actualizată!"
    else
      render :edit
    end
  end

  def destroy
    @jogging_entry.destroy
    redirect_to jogging_entries_path, notice: "Alergare ștearsă!"
  end

  private

  # ❌ MANAGERUL NU ARE VOIE NICI MĂCAR SĂ VADĂ
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
