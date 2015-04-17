class Todo < ActiveRecord::Base
  extend Enumerize
  enumerize :status, in: [:new, :started, :done]
  belongs_to :requester, class_name: User
  belongs_to :assignee, class_name: User
end
