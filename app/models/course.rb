class Course < ActiveRecord::Base
  has_and_belongs_to_many :schedules
  has_many :users, through: :schedules

  def friends_enrolled(user)
    self.users & user.friends
  end

  def room_link
    return nil if self.room == 'TBA'
    "https://www.utdallas.edu/locator/#{self.room.gsub(' ', '_')}"
  end

end
