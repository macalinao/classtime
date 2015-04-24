class Schedule < ActiveRecord::Base
  belongs_to :user
  belongs_to :semester

  has_and_belongs_to_many :courses

  def self.import_from_string(str)
    schedule = Schedule.new

    # Array to hold our courses
    courses = []

    # Current course info
    course = nil

    lines = str.split(/[\r]*\n/)
    lines.each do |line|
      # Course name
      if /^[A-Z]{2,4} [\d]{4}/ =~ line

        split = line.split(' - ')
        course = {
          name: split[1],
          number: split[0]
        }

        courses << course

      # Ignore rest unless there's a course
      elsif not course
        next

      # Credits
      elsif course.has_key?(:name) and not course.has_key?(:credits)
        course[:credits] = Float(line).to_i if /^[\d]+/ =~ line

      elsif course.has_key?(:credits) and not course.has_key?(:start_time)
        next unless /^[A-Za-z]{4} [\d]/ =~ line
        split = line.split(' ')
        course[:days] = split[0]
        course[:start_time] = Time.parse split[1]
        course[:end_time] = Time.parse split[3]

      elsif course.has_key?(:start_time) and not course.has_key?(:room)
        course[:room] = line

      elsif course.has_key?(:room) and not course.has_key?(:instructor)
        course[:instructor] = line

      elsif course.has_key?(:instructor) and not course.has_key?(:starts_at)
        split = line.split(' - ')
        next unless split.length == 2
        course[:starts_at] = Date.strptime(split[0], '%m/%d/%Y')
        course[:ends_at] = Date.strptime(split[1], '%m/%d/%Y')

      end
    end

    schedule = Schedule.new

    # Add courses
    courses.each do |course|
      c = Course.where(course)
      schedule.courses << (c.empty? ? Course.create(course) : c[0])
    end

    return schedule
  end
end
