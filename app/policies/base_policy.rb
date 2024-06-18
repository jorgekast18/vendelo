class BasePolicy
  attr_reader :record
  def initialize(record)
    @record = record
  end

  private def method_missing(name, *args)
    false
  end
end