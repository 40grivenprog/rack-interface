# frozen_string_literal: true

class TimeFormat
  AVAILIABLE_PARAMS = { 'year' => '%Y', 'month' => '%m', 'day' => '%d', 'hour' => '%H', 'minute' => '%M', 'second' => '%M' }.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    if env['REQUEST_PATH'] != '/time'
      status = 404
      body = ['Incorrect path']
      [status, headers, body]
    else
      parse_query_string(env['QUERY_STRING'], headers)
    end
  end

  private

  def parse_query_string(params, headers)
    return [404, headers, ['No params']] if params.empty?

    format_keys = params[/format=(.*)/, 1].split('%2C')
    incorrect_keys = (format_keys - AVAILIABLE_PARAMS.keys)
    if !incorrect_keys.empty?
      body = ["Unknown time format [#{incorrect_keys.join(', ')}]"]
      status = 404
    else
      body = [Time.now.strftime(make_body(format_keys))]
      status = 200
    end
    [status, headers, body]
  end

  def make_body(format)
    format.map do |format_param|
      AVAILIABLE_PARAMS[format_param]
    end.join(' - ')
  end
end

