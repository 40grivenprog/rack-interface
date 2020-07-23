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
      response.write('Incorrect path')
    end
    response['Content-Type'] = 'text/plain'
    response.finish
  end

  private

  def correct_path?(path)
    path == '/time'
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end
end
