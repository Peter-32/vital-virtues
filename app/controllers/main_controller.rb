class MainController < ApplicationController

  def index
    time = Time.now.to_s(:db)
    @weeks = Week.find_by_sql("SELECT id, week_number, day, start_date, virtue, sunday, monday, tuesday, wednesday, thursday, friday, saturday FROM weeks ORDER BY id ASC")
    @days = Week.find_by_sql("SELECT virtue, description, website FROM weeks a INNER JOIN (SELECT MAX(start_date) AS start_date FROM weeks where start_date < '#{time}') b on a.start_date = b.start_date")
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
      inserts.push "(#{row}, '#{newTime.mday}', '#{newTime}', '#{random_virtue[0]}', '#{random_virtue[2]}', '#{random_virtue[1]}',  '#{time}', '#{time}')"
      newTime = newTime + 24*60*60*7
      row = row + 1
    end
    sql = "INSERT INTO weeks (week_number, day, start_date, virtue, description, website, created_at, updated_at) VALUES #{inserts.join(", ")}"
    ActiveRecord::Base.connection.execute(sql)

    redirect_to main_path
  end

  def _get_random_virtues
    # Use a dictionary here with 3 qualities
    virtues = [["Idealism",	"https://en.wikipedia.org/wiki/Idealism",	"Imagination and attempts to realize a mental conception of the world as it might be or should be"],
["Creativity",	"https://en.m.wikipedia.org/wiki/Creativity",	"Creativity is a phenomenon whereby something new and somehow valuable is formed."],
["Flexibility",	"https://en.m.wikipedia.org/wiki/Flexibility_(personality)",	"Can cope with changes in circumstances and think about problems and tasks in novel, creative ways"],
["Frugality",	"https://en.m.wikipedia.org/wiki/Frugality#",	"Prudent or economical in the consumption of consumable resources such as food, time or money, and avoiding waste, lavishness or extravagance."],
["Temperance",	"https://en.m.wikipedia.org/wiki/Temperance_(virtue)",	"Calmness and self-control, with restraint from violence, arrogance, anger, excesses, and cravings.  "],
["Moderation",	"https://en.m.wikipedia.org/wiki/Moderation",	"Moderation is the process of eliminating or lessening extremes."],
["Tranquility",	"https://en.m.wikipedia.org/wiki/Tranquillity",	"The quality or state of being tranquil; that is, calm, serene, and worry-free."],
["Humanity",	"https://en.m.wikipedia.org/wiki/Humanity_(virtue)",	"Looking out for the wellness of others more so than the fairness in justice."],
["Equanimity",	"https://en.m.wikipedia.org/wiki/Equanimity",	"A state of psychological stability and composure which is undisturbed by experience of or exposure to emotions, pain, or other phenomena that may cause others to lose the balance of their mind"],
["Determination",	"https://en.m.wikipedia.org/wiki/Determination",	"A positive emotional feeling that involves persevering towards a difficult goal in spite of obstacles"],
["Discipline",	"https://en.m.wikipedia.org/wiki/Discipline",	"Discipline is action or inaction that is regulated to be in accordance with a system"],
["Consistency",	"about:blank",	"Following a system daily"],
["Industry",	"about:blank",	"Doing something useful"],
["Reliable",	"about:blank",	"Will remember to do tasks and do them"],
["Responsible",	"about:blank",	"Is in charge of tasks being completed and will take the blame if they are unsuccessful"],
["Excellence",	"https://en.m.wikipedia.org/wiki/Excellence",	"Excellence is a talent or quality which is unusually good and so surpasses ordinary standards"],
["Courage",	"https://en.m.wikipedia.org/wiki/Courage",	"The choice and willingness to confront agony, pain, danger, uncertainty, or intimidation"],
["Assertiveness",	"https://en.m.wikipedia.org/wiki/Assertiveness",	"Being self-assured and confident without being aggressive"],
["Honor",	"https://en.m.wikipedia.org/wiki/Honour",	"An abstract concept entailing a perceived quality of worthiness and respectability that affects both the social standing and the self-evaluation of an individual or institution such as a family, school, regiment or nation"],
["Confidence",	"https://en.m.wikipedia.org/wiki/Confidence",	"Common meaning of a certainty about handling something, such as work, family, social events, or relationships"],
["Obedience",	"https://en.m.wikipedia.org/wiki/Obedience_(human_behavior)",	"A person yields to explicit instructions or orders from an authority figure"],
["Order",	"https://en.m.wikipedia.org/wiki/Orderliness",	"Associated with other qualities such as cleanliness and diligence, and the desire for order and symmetry, and is generally considered to be a desirable quality."],
["Cleanliness",	"https://en.m.wikipedia.org/wiki/Cleanliness",	"Related to hygiene and disease prevention.  Also avoiding things that harm your health such as drugs."],
["Chastity",	"https://en.m.wikipedia.org/wiki/Chastity",	"Sexual conduct of a person that is deemed praiseworthy and virtuous according to the moralstandards and guidelines of their culture, civilization or religion"],
["Humility",	"https://en.m.wikipedia.org/wiki/Humility",	"Dictionary definitions accentuate humility as a low self-regard and sense of unworthiness."],
["Justice",	"https://en.m.wikipedia.org/wiki/Justice",	"Legal or philosophical theory by which fairness is administered"],
["Modesty",	"https://en.m.wikipedia.org/wiki/Modesty",	"A mode of dress and deportment which intends to avoid encouraging of sexual attraction in others"],
["Reverence",	"https://en.m.wikipedia.org/wiki/Reverence_(emotion)",	"Reverence involves a humbling of the self in respectful recognition of something perceived to be greater than the self"],
["Respect",	"https://en.m.wikipedia.org/wiki/Respect",	"A positive feeling or action shown towards someone or something considered important, or held in high esteem or regard"],
["Hope",	"https://en.m.wikipedia.org/wiki/Hope",	"Hope is an optimistic state of mind that is based on an expectation of positive outcomes with respect to events and circumstances in your life or the world at large"],
["Joyfulness",	"https://en.m.wikipedia.org/wiki/Joy",	"The word joy means a feeling of great pleasure and happiness"],
["Enthusiasm",	"https://en.m.wikipedia.org/wiki/Enthusiasm",	"Enthusiasm is intense enjoyment, interest, or approval"],
["Honesty",	"https://en.m.wikipedia.org/wiki/Honesty",	"A facet of moral character and connotes positive and virtuous attributes such as integrity, truthfulness, straightforwardness, including straightforwardness of conduct, along with the absence of lying, cheating, theft, etc"],
["Sincerity",	"https://en.m.wikipedia.org/wiki/Sincerity",	"The virtue of one who communicates and acts in accordance with their feelings, beliefs, thoughts, and desires"],
["Trustworthiness",	"https://en.m.wikipedia.org/wiki/Trust_(emotion)",	"Others can abandon control over actions to you and have a good degree of certainty of the outcome of your actions"],
["Faith",	"https://en.m.wikipedia.org/wiki/Faith",	"Confidence or trust in a particular system of religious belief,[1]in which faith may equate to confidence based on some perceived degree of warrant"],
["Prayerfulness",	"about:blank",	"Prays daily"],
["Wisdom",	"https://en.m.wikipedia.org/wiki/Wisdom",	"The ability to think and act using knowledge, experience, understanding, common sense, and insight"],
["Kindness",	"https://en.m.wikipedia.org/wiki/Kindness",	"A pleasant disposition, and a concern for others"],
["Silence",	"about:blank",	"Avoid triffling conversions.  Speak when it will benefit others or you."],
["Gentleness",	"https://en.m.wikipedia.org/wiki/Gentleness",	"Being detached in a situation where anger is appropriate; justified and properly focused anger is named mildness or gentleness"],
["Courtesy",	"https://en.m.wikipedia.org/wiki/Courtesy",	"Is gentle politeness and courtlymanners"],
["Tolerance",	"https://en.m.wikipedia.org/wiki/Toleration",	"The acceptance of an action, object, or person which one dislikes or disagrees with, where one is in a position to disallow it but chooses not to"],
["Faithfulness",	"https://en.m.wikipedia.org/wiki/Faithfulness",	"The concept of unfailingly remaining loyal to someone or something, and putting that loyalty into consistent practice regardless of extenuating circumstances"],
["Friendliness",	"about:blank",	"Befriending others.  Being a good friend: challenging others to be the best version of themselves.  Encouraging them, challenging them, listening to them, and keeping them accountable."],
["Generosity",	"https://en.m.wikipedia.org/wiki/Generosity",	"The virtue of being unattached to material possessions, often symbolized by the giving of gifts"],
["Service",	"about:blank",	"In interactions with others ask yourself how I can serve this person"],
["Charity",	"https://en.m.wikipedia.org/wiki/Charity_(virtue)",	"We love God above all things for His own sake, and our neighbor as ourselves for the love of God"],
["Helpfulness",	"https://en.m.wikipedia.org/wiki/Helpfulness",	"The everyday concept of helpfulness is the property of providing useful assistance; or friendliness evidenced by a kindly and helpful disposition"],
["Patience",	"https://en.m.wikipedia.org/wiki/Patience",	"The state of endurance under difficult circumstances such as: perseverance and/or the ability to wait in the face of delay"],
["Forgiveness",	"https://en.m.wikipedia.org/wiki/Forgiveness",	"The intentional and voluntary process by which a victim undergoes a change in feelings and attitude regarding an offense, lets go of negative emotions such as vengefulness, with an increased ability to wish the offender well"],
["Mercy",	"https://en.m.wikipedia.org/wiki/Mercy",	"A broad term that refers to benevolence, forgiveness, and kindness in a variety of ethical, religious, social, and legal contexts"],
["Love",	"https://en.m.wikipedia.org/wiki/Love",	"Encompasses a variety of different emotional and mental states, typically strongly and positively experienced, ranging from the deepest interpersonal affection to the simplest pleasure"],
["Trust",	"https://en.m.wikipedia.org/wiki/Trust_(emotion)",	"Can abandon control over your actions to others and have a good degree of certainty of the outcome of your actions"],
["Thankfulness",	"https://en.m.wikipedia.org/wiki/Gratitude",	"A feeling of appreciation felt by and/or similar positive response shown by the recipient of kindness, gifts, help, favors, or other types of generosity, towards the giver of such gifts"]]
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
