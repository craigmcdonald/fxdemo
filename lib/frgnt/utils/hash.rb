class Hash

  def fetch!(key, &block)
    value = fetch(key,&block)
    return value if value.length > 0
    yield
  end

  def transform_keys_to_symbols(object=self)
    case object
    when Hash
      object.each_with_object({}) do |(k,v), res|
        res[k.to_sym] = transform_keys_to_symbols(v)
      end
    else
      object
    end
  end
end
