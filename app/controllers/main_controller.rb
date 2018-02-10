class MainController < ApplicationController

  def index
    @weeks = Week.find_by_sql("SELECT id, week_number, day, start_date, virtue, sunday, monday, tuesday, wednesday, thursday, friday, saturday FROM weeks ORDER BY id ASC")
  end

  def reset
    sql = "DELETE FROM weeks"
    ActiveRecord::Base.connection.execute(sql)

    random_virtues = _get_random_virtues

    inserts = []
    time = Time.now.to_s(:db)
    newTime = Time.now
    newTime = newTime - newTime.wday*24*60*60

    row = 1
    random_virtues.each do |random_virtue|
      #newTime.to_s(:db)
      inserts.push "(#{row}, '#{newTime.mday}', '#{newTime}', '#{random_virtue}', '#{time}', '#{time}')"
      newTime = newTime + 24*60*60*7
      row = row + 1
    end
    sql = "INSERT INTO weeks (week_number, day, start_date, virtue, created_at, updated_at) VALUES #{inserts.join(", ")}"
    ActiveRecord::Base.connection.execute(sql)

    redirect_to main_path
  end

  def _get_random_virtues
    virtues = ["Idealism","Creativity","Flexibility","Unity","Frugality","Temperance","Moderation","Tranquility","Humanity","Equanimity","Detachment","Determination","Discipline","Consistency","Industry","Reliable","Responsible","Excellence","Bravery","Resolution","Assertiveness","Honor","Confidence","Courage",
      "Obedience","Purity","Order","Cleanliness","Chastity","Humility","Justice","Modesty","Reverence","Respect","Hope","Joyfulness","Enthusiasm","Honesty","Truthfulness","Sincerity","Trustworthiness",
      "Faith","Prayerfulness","Wisdom","Kindness","Silence","Gentleness","Caring","Consideration","Courtesy","Tolerance","Faithfulness","Friendliness","Generosity","Service","Charity","Helpfulness","Patience","Forgiveness,","Mercy","Love","Trust","Thankfulness"]
    random_virtues = virtues.sample(12)
    return random_virtues
  end

  def messed_up
    _update_today_as('X')
    redirect_to main_path
  end

  def undo
    _update_today_as('')
    redirect_to main_path
  end

  def _update_today_as(new_value)
    weeks = Week.find_by_sql("SELECT week_number, start_date FROM weeks ORDER BY id asc")
    # correct_id = nil
    # wday = nil
    # wday_name = nil
    # last_date = nil
    time = Time.now
    puts time
    weeks.each do |week|
      last_date = week.start_date
      if (time < week.start_date)
        puts week.start_date
        week_number = week.week_number.to_i - 1
        puts week_number
        wday = week.start_date.day - time.day
        wday = 7 - wday
        wday_name = _getWDayName(wday)
        sql = "UPDATE weeks SET #{wday_name} = '#{new_value}' WHERE week_number = '#{week_number}'"
        ActiveRecord::Base.connection.execute(sql)
        return
      end
    end
    week_number = 12
    wday = last_date - time
    wday_name = _getWDayName(wday)
    sql = "UPDATE weeks SET #{wday_name} = '#{new_value}' WHERE week_number = '#{week_number}'"
    ActiveRecord::Base.connection.execute(sql)
  end

  def _getWDayName(wday)
    wday_name = nil
    if (wday == 0)
      wday_name = "sunday"
    elsif (wday == 1)
      wday_name = "monday"
    elsif (wday == 2)
      wday_name = "tuesday"
    elsif (wday == 3)
      wday_name = "wednesday"
    elsif (wday == 4)
      wday_name = "thursday"
    elsif (wday == 5)
      wday_name = "friday"
    elsif (wday == 6)
      wday_name = "saturday"
    end
    return wday_name
  end

end
