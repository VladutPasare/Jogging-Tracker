class JoggingEntry < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :distance, numericality: true
  validates :duration, numericality: true

  def average_speed
    return 0 if duration.to_f.zero?
    (distance / (duration / 60.0))
  end

  # ---- RAPORT SAPTAMANAL ----
  def self.weekly_report_for(user)
    where(user: user)
      .group("strftime('%Y-%W', date)")
      .select(
        "strftime('%Y-%W', date) as week,
         AVG(distance) as avg_distance,
         AVG(duration) as avg_duration"
      )
  end
end
