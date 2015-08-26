require 'set'
require_relative 'follow'

class UserLineFormatError < StandardError; end
class UserLine
  def initialize(line)
    @line = line
  end

  def valid?
    VALID_PATTERN === @line
  end

  def follows
    raise UserLineFormatError.new(@line) unless valid?

    subscriber, broadcasters = @line.split(/follows/i).map(&:strip)
    broadcasters.split(',').map(&:strip).inject(Set.new) { |set, broadcaster|
      set.add Follow.new(broadcaster, subscriber)
    }.to_a
  end

  private
  # Assuming that every line in a valid file
  # has at least one user on the right hand
  # side of follows and that names can only contain
  # \w characters.
  VALID_PATTERN = /\w+ follows [\w, ]+/i
end
