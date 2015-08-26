require 'set'
require_relative 'follow'

class UserLine
  def initialize(line)
    @line = line
  end

  def valid?
    VALID_PATTERN === @line
  end

  def follows
    return {} unless valid?

    subscriber, broadcasters = @line.split('follows').map(&:strip)
    broadcasters.split(',').map(&:strip).inject(Set.new) { |set, broadcaster|
      set.add Follow.new(broadcaster, subscriber)
    }.to_a
  end

  private
  # Assuming that every line in a valid file
  # has at least one user on the right hand
  # side of follows
  VALID_PATTERN = /.+ follows .+/i
end
