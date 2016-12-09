class Op::Response::Error < StandardError; end

class Op::Response::InvalidMessageError < Op::Response::Error
  def initialize(message)
    if message == ''
      message = '[empty string]'
    else
      message = "#{message}:#{message.class}"
    end
    super("Invalid message (message=#{message}), has to be non-empty String")
  end
end

class Op::Response::InvalidStatusError < Op::Response::Error
  def initialize(status, allowed_statuses)
    super("Invalid status (status=#{status}), has to be in [#{allowed_statuses.join(', ')}])")
  end
end
