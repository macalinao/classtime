class Schedule < ActiveRecord::Base
  belongs_to :user
  belongs_to :semester

  has_and_belongs_to_many :courses

  validates :semester, presence: true
  validates :user, presence: true

  def credits
    courses.reduce 0 do |sum, course|
      sum + course.credits
    end
  end

  def self.import_from_string(str, user)
    schedule = Schedule.new

    # Array to hold our courses
    courses = []

    # Current course info
    course = nil

    # Semester
    semester = nil

    lines = str.split(/[\r]*\n/)
    lines.each do |line|

      if /^[\d]{4}/ =~ line and course.nil?
        split = line.split(' > ')
        semester_name = split[0]
        semester = Semester.where(name: semester_name).first || Semester.create({
          name: semester_name,
          school: School.where(name: split[2]).first || School.create(name: split[2])
        })

      # Course name
      elsif /^[A-Z]{2,4} [\d]{4}/ =~ line

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

      elsif course.has_key?(:credits) and not course.has_key?(:section)
        next unless /^[A-Z\d]{3}$/ =~ line
        course[:section] = line

      # Time
      elsif course.has_key?(:section) and not course.has_key?(:start_time) and /^[A-Za-z]{4} [\d]/ =~ line
        split = line.split(' ')
        course[:days] = split[0]
        course[:start_time] = Time.parse(split[1] + ' UTC')
        course[:end_time] = Time.parse(split[3] + ' UTC')

      elsif course.has_key?(:credits) and not course.has_key?(:room)
        next unless /^[A-Z]{2}/ =~ line
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

    schedule = Schedule.new semester: semester, user: user

    # Add courses
    courses.each do |course|
      c = Course.where(course)
      schedule.courses << (c.empty? ? Course.create(course) : c[0])
    end

    return schedule
  end
end
