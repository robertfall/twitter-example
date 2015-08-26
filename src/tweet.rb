Tweet = Struct.new(:broadcaster, :body) do
  def to_s
    "@#{broadcaster}: #{body}"
  end

  def inspect
    to_s
  end
end
