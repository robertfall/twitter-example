require_relative 'tweet'

class TweetLineFormatError < StandardError; end
class TweetLine
  def initialize(line)
    @line = line
  end

  def broadcaster
    raise TweetLineFormatError.new(@line) unless valid?

    tweet.broadcaster
  end

  def body
    raise TweetLineFormatError.new(@line) unless valid?

    tweet.body
  end

  def valid?
    VALID_PATTERN === @line
  end

  def ==(other)
    self.broadcaster == other.broadcaster and
      self.body == other.body
  end

  def tweet
    raise TweetLineFormatError.new(@line) unless valid?
    return @tweet if @tweet

    broadcaster, body = @line.split('> ')
    @tweet = Tweet.new(broadcaster, body)
  end
  private
  # Assuming that tweets that are too long are invalid
  # and that names can only contain \w characters
  VALID_PATTERN = /\w+\> .{1,140}$/i
end
