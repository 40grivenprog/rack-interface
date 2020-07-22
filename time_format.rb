# frozen_string_literal: true
require_relative 'app'

class TimeFormatter
  AVAILIABLE_PARAMS = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'hour' => '%H', 'minute' => '%M', 'second' => '%M' }.freeze

  def initialize(params)
    @params = params
  end

  def call
   return 'No params' if @params.empty?
   format_keys = @params[/format=(.*)/, 1].split('%2C')
   incorrect_keys = (format_keys - AVAILIABLE_PARAMS.keys)
   if !incorrect_keys.empty?
    ["Unknown time format [#{incorrect_keys.join(', ')}]"]
   else
    Time.now.strftime(make_body(format_keys))
   end

  end

  private

  def make_body(format)
    format.map do |format_param|
      AVAILIABLE_PARAMS[format_param]
    end.join('-')
  end
end

