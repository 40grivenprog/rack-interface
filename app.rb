# frozen_string_literal: true
require_relative 'time_format'

class App

  def call(env)
    response = Rack::Response.new
    if correct_path?(env['REQUEST_PATH'])
      time_formatter = TimeFormatter.new(env['QUERY_STRING'])
      response.write(time_formatter.call)
      response.status = time_formatter.success ? 200 : 400
    else
      response.status = 404
      response.write("Incorrect path")
    end
    response['Content-Type'] = "text/plain"
    response.finish
  end

  private

  def correct_path?(path)
    path == '/time'
  end

  def status(env)
    # return 404 if env['REQUEST_PATH'] != '/time'
    # return 400 if env['QUERY_STRING'].empty?
    # return 400 unless (env['QUERY_STRING'][/format=(.*)/, 1].split('%2C') - TimeFormatter::AVAILIABLE_PARAMS.keys).empty?
    # 200
    # env['REQUEST_PATH'] == '/time' ? 200 : 404
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

end

