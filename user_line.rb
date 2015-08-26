require 'set'

require 'minitest/autorun'

Follow = Struct.new(:broadcaster, :subscriber)

class UserLine
  def initialize(line)
    @line = line
  end

  def valid?
    VALID_PATTERN === @line
  end

  def follows
    return {} unless valid?

    # TODO: Handle case issues
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

VALID_LINES = ['Rob follows John', 'Rob follows John, Rich, Toby, John']
INVALID_LINES = ['Rob', '', 'Rob > John', 'follows John', 'Rob follows']

describe UserLine do
  describe '#follows' do
    it 'returns all users with their follower' do
      UserLine.new(VALID_LINES.first).
        follows.must_equal([Follow.new('John', 'Rob')])

      UserLine.new(VALID_LINES.last).
        follows.must_equal([
          Follow.new('John', 'Rob'),
          Follow.new('Rich', 'Rob'),
          Follow.new('Toby', 'Rob')
        ])
    end
  end

  describe '#valid?' do
    describe 'with valid line' do
      VALID_LINES.each do |line|
        let (:user_line) { UserLine.new(line) }
        it 'must be true' do
          user_line.valid?.must_equal true
        end
      end
    end

    describe 'with invalid line' do
      INVALID_LINES.each do |line|
        let (:user_line) { UserLine.new(line) }
        it 'must be false' do
          user_line.valid?.must_equal false
        end
      end
    end
  end
end
