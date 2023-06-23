# frozen_string_literal: true

require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(address: zip, levels: 'country',
                                              roles: %w[legislatorUpperBody legislatorLowerBody]).officials
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def eleven_digits_start_with_one?(to_string)
  to_string.length == 11 && to_string.chars.first == '1'
end

def less_than_ten_digits?(to_string)
  to_string.length < 10
end

def remove_special_characters(phone_number)
  phone_number.to_s.gsub(/(?!^\+)\D*/, '')
end

def clean_phone_number(phone_number)
  to_string = remove_special_characters(phone_number)

  if eleven_digits_start_with_one?(to_string)
    to_string[1..]
  elsif less_than_ten_digits?(to_string)
    '0' * 10
  else
    to_string
  end
end

puts 'EventManager initialized.'

contents = CSV.open('event_attendees.csv', headers: true, header_converters: :symbol)

template_letter = File.read('form_letter.erb')
ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  phone_number = clean_phone_number(row[:homephone])
  date = row[:regdate]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

end

def parse_date(date)
  Time.strptime(date, '%m/%d/%y %H:%M')
end

def extract_csv_dates(csv)
  csv.map do |row|
    date = row[:regdate]
    parse_date(date)
  end
end

# Extracts the date from csv
module Extractable
  def parse_date(date)
    Time.strptime(date, '%m/%d/%y %H:%M')
  end

  def extract_csv_dates(csv)
    csv.map do |row|
      date = row[:regdate]
      parse_date(date)
    end
  end
end

# Group items
module Groupable
  def group_top(data)
    data
      .tally
      .sort_by(&:last)
      .last(size)
      .reverse
  end
end

# Shows top registration hours
class TopRegistrationHours
  include Extractable
  include Groupable

  def initialize(csv_content, size = 3)
    @csv_content = csv_content
    @size = size
  end

  def show
    extract_csv_dates(csv_content)
      .then(&method(:to_hours))
      .then(&method(:group_top))
      .then(&method(:display_top_hours))
  end

  private

  def display_top_hours(top_hours)
    puts "The top #{size} hours are:"
    top_hours.each_with_index do |(hour, occurrences), index|
      puts " n°#{index + 1}: #{hour}h with #{occurrences} registrations"
    end
  end

  def to_hours(dates)
    dates.map(&:hour)
  end

  attr_reader :size, :csv_content
end

# Show top registration week days
class TopWeekDays
  include Extractable
  include Groupable

  def initialize(csv_content, size = 3)
    @csv_content = csv_content
    @size = size
  end

  def show
    extract_csv_dates(csv_content)
      .then(&method(:to_week_day))
      .then(&method(:group_top))
      .then(&method(:display_top_days))
  end

  private

  def to_week_day(dates)
    dates.map { |date| Date::DAYNAMES[date.wday] }
  end

  def display_top_days(top_days)
    puts "The top #{size} week days are:"
    top_days.each_with_index do |(week_day, occurrences), index|
      puts " n°#{index + 1}: #{week_day} with #{occurrences} registrations"
    end
  end

  attr_reader :csv_content, :size
end

