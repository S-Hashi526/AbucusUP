class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  # 出勤・退勤時間がどちらも存在かつ翌日チェックがない場合、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid
  # 出勤変更・退勤変更時間がどちらも存在かつ翌日チェックがない場合、出勤変更時間より早い退勤変更時間は無効
  validate :change_started_at_than_change_finished_at_fast_if_invalid
  
  def started_at_is_invalid_without_a_finished_at
    errors.add(:finished_at, "が未入力です。") if finished_at.blank? && started_at.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present? && !next_day.present?
      errors.add(:started_at, "より早い退勤時間が入力されています。") if started_at > finished_at
    end
  end
    
  def change_started_at_than_change_finished_at_fast_if_invalid
    if change_started_at.present? && change_finished_at.present? && !next_day.present?
      errors.add(:started_at, "より早い退勤時間が入力されています。") if change_started_at > change_finished_at
    end
  end

end