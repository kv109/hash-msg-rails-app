class Op::Response
  STATUSES = %i(ok error).freeze; private_constant :STATUSES

  STATUSES_MAP = {
    true => :ok,
    false => :error
  }.freeze; private_constant :STATUSES_MAP

  attr_reader :messages, :status, :value

  def initialize(messages: [], status:, value: nil)
    @messages = messages
    @status = build_status(status)
    @value = value
  end

  def error(&block)
    block.call(value, messages) if error?
    self
  end

  def ok(&block)
    block.call(value) if ok?
    self
  end

  def to_s
    [].tap do |string|
      string << "status=#{status}"
      string << "messages=#{messages.join(', ')}" if messages.present?
      string << "value=#{value}" if value
    end.join(', ').insert(0, 'RESULT: ')
  end

  def error?; status == :error end
  def not_found?; status == :not_found end
  def ok?; status == :ok end

  private

  def build_status(status)
    status = STATUSES_MAP[status] || status
    unless status.in? STATUSES
      raise "Invalid status (status=#{status}, has to be in [#{STATUSES.join(', ')}])"
    end
    status
  end
end
