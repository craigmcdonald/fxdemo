class Hash
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
