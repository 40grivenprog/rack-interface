# frozen_string_literal: true
require_relative 'app'

class TimeFormatter
  AVAILIABLE_PARAMS = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'hour' => '%H', 'minute' => '%M', 'second' => '%M' }.freeze
  attr_accessor :success

  def initialize(params)
    @params = params
    @success = false
  end

  def call
   return 'No params' if @params.empty?
   format_keys = get_format_keys_from_params
   incorrect_keys = check_incorrect_keys(format_keys)
   if !incorrect_keys.empty?
    make_unsuccess_body(incorrect_keys)
   else
    @success = true
    make_success_body(format_keys)
   end
  end

  private

  def get_format_keys_from_params
    @params[/format=(.*)/, 1].split('%2C')
  end

  def check_incorrect_keys(format_keys)
   incorrect_keys = (format_keys - AVAILIABLE_PARAMS.keys)
  end

  def make_unsuccess_body(incorrect_keys)
    "Unknown time format [#{incorrect_keys.join(', ')}]"
  end

  def make_success_body(format)
    keys_for_time = format.map do |format_param|
      AVAILIABLE_PARAMS[format_param]
    end.join('-')
    Time.now.strftime(keys_for_time)
  end
end

