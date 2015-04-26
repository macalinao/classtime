class SchedulesController < ApplicationController
  before_action :authenticate_user!

  def index
    @schedules = Schedule.where user: current_user
    @friends = current_user.friends
  end

  def new
  end

  def create
    begin
      schedule = Schedule.import_from_string params[:create][:schedule], current_user
      schedule.save()
      redirect_to schedule_path(schedule)
    rescue StandardError => e
      flash[:error] = 'Invalid data: ' + e.message + '\n' + e.backtrace[0..5].join('\n')
      redirect_to new_schedule_path
    end
  end

  def show
    @schedule = Schedule.find params[:id]
  end

end
