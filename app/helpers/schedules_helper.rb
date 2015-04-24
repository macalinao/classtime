module SchedulesHelper
  def time(time)
    time.strftime('%I:%M %p') rescue ''
  end
end
