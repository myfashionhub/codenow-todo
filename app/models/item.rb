class Item < ActiveRecord::Base
  validates :state,
    inclusion: { in: ['queued', 'active', 'done'] }
end
