require "minitest/autorun"

class UserLine
  def initialize(line)
    @line = line
  end

  def valid?
    VALID_PATTERN === @line
  end

  def follows_by_user
    return {} unless valid?

    # TODO: Handle case issues
    left, right = @line.split('follows').map(&:strip)
    { left => right.split(',').map(&:strip) }
  end

  private
  # Assuming that every line in a valid file
  # has at least one user on the right hand
  # side of follows
  VALID_PATTERN = /.+ follows .+/i
end

VALID_LINES = ['Rob follows John', 'Rob follows John, Rich, Toby']
INVALID_LINES = ['Rob', '', 'Rob > John', 'follows John', 'Rob follows']

describe UserLine do
  describe "#follows_by_user" do
    it "returns all users with their follows" do
      UserLine.new(VALID_LINES.first).
        follows_by_user.must_equal({'Rob' => ['John']})
    end
  end

  describe "#valid?" do
    describe "with valid line" do
      VALID_LINES.each do |line|
        let (:user_line) { UserLine.new(line) }
        it "must be true" do
          user_line.valid?.must_equal true
        end
      end
    end

    describe "with invalid line" do
      INVALID_LINES.each do |line|
        let (:user_line) { UserLine.new(line) }
        it "must be false" do
          user_line.valid?.must_equal false
        end
      end
    end
  end
end
