class Op::Response::Error < StandardError; end

class Op::Response::InvalidStatusError < Op::Response::Error
  def initialize(status, allowed_statuses)
    super("Invalid status (status=#{status}), has to be in [#{allowed_statuses.join(', ')}])")
  end
end
