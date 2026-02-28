class ApplicationQuery
  def initialize(relation = default_scope)
    @relation = relation
  end

  def call
    raise NotImplementedError, 'Subclasses must implement #call'
  end

  private

  def default_scope
    raise NotImplementedError, 'Subclasses must define default_scope'
  end
end
