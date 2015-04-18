class Todo < ActiveRecord::Base
  extend Enumerize
  enumerize :status, in: [:new, :started, :done]
  belongs_to :requester, class_name: User
  belongs_to :assignee, class_name: User

  validates :requester_id, presence: true

  self.per_page = 10

  def deadline_exceeded?
    deadline < Date.today unless deadline.nil?
  end
end
