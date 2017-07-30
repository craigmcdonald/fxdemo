class Hash
  def fetch!(key, &block)
    value = fetch(key,&block)
    return value if value.length > 0
    yield
  end
end
