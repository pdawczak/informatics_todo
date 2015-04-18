class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :todos_requested, class_name: "Todo",
                             foreign_key: "requester_id"

  has_many :todos_assigned, class_name: "Todo",
                            foreign_key: "assignee_id"

  def name
    email && email.split('@').first
  end
end
