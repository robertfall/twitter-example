class TweetLineFormatError < StandardError; end
class TweetLine
  def initialize(line)
    @line = line
  end

  def broadcaster
    raise TweetLineFormatError.new(@line) unless valid?

    parts[:broadcaster]
  end

  def body
    raise TweetLineFormatError.new(@line) unless valid?

    parts[:body]
  end

  def valid?
    VALID_PATTERN === @line
  end

  private
  # Assuming that tweets that are too long are invalid
  # and that names can only contain \w characters
  VALID_PATTERN = /\w+\> .{1,140}$/i

  def parts
    return @parts if @parts

    broadcaster, body = @line.split('> ')
    @parts = { broadcaster: broadcaster, body: body}
  end
end
