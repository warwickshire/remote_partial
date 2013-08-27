
module TimeCalc

  def self.days(number)
    hours(number) * hours_in_a_day
  end

  def self.hours(number)
    minutes(number) * minutes_in_an_hour
  end

  # returns seconds in number of minutes
  def self.minutes(number)
    number * seconds_in_a_minute
  end

  def self.ago(seconds)
    Time.now - seconds
  end

  def self.minutes_ago(number)
    ago(minutes(number))
  end

  def self.hours_ago(number)
    ago(hours(number))
  end

  def self.days_ago(number)
    ago(days(number))
  end

  def self.seconds_in_a_minute
    60
  end

  def self.minutes_in_an_hour
    60
  end

  def self.hours_in_a_day
    24
  end

end
