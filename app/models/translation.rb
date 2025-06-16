class Translation < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :message

  enum :status, {
    pending: "pending", 
    in_progress: "in_progress", 
    completed: "completed", 
    failed: "failed"
  }
end