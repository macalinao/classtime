class Course < ActiveRecord::Base
  has_and_belongs_to_many :schedules
  has_many :users, through: :schedules

  def friends_enrolled(user)
    self.users & user.friends
  end
end
