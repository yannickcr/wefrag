class Hash
  # Hash intersection. Two hashes intersect
  # when their pairs are equal.
  #
  #   {:a=>1,:b=>2} & {:a=>1,:c=>3}  #=> {:a=>1}
  #
  # A hash can also be intersected with an array
  # to intersect by keys only.
  #
  #   {:a=>1,:b=>2} & [:a,:c]  #=> {:a=>1}
  #
  # The later form is similar to #pairs_at. This differs only
  # in that #pairs_at will return a nil value for a key
  # not in the hash, but #& will not.

  def &(other)
    case other
    when Array
      k = (keys & other)
      Hash[*(k.zip(values_at(*k)).flatten)]
    else
      r = (to_a & other.to_a).inject([]) do |a, kv|
        a.concat kv; a
      end
      Hash[*r]
    end
  end
end
