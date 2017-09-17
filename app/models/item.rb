class Item < ActiveRecord::Base
  def self.statuses
    ['queued', 'active', 'done']
  end

  validates :name, presence: true
  validates :status,
    inclusion: { in: self.statuses }
end
