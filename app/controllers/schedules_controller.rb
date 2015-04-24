class SchedulesController < ApplicationController

  def new
  end

  def create
    begin
      schedule = Schedule.import_from_string params[:create][:schedule]
      schedule.save()
      redirect_to schedules_path
    rescue StandardError => e
      flash[:error] = 'Invalid data: ' + e.message + '\n' + e.backtrace[0..5].join('\n')
      redirect_to new_schedules_path
    end
  end

end
