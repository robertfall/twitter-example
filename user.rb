require "minitest/autorun"

class UserLine
  def initialize(line)
    @line = line
  end

  def valid?
    VALID_PATTERN === @line
  end

  private
  # Assuming that every line in a valid file
  # has at least one user on the right hand
  # side of follows
  VALID_PATTERN = /.+ follows .+/i
end

VALID_LINES = ['Rob follows John', 'Rob follows John, Rich']
INVALID_LINES = ['Rob', '', 'Rob > John', 'follows John', 'Rob follows']

describe UserLine do
  describe "#valid?" do
    describe "with valid line" do
      VALID_LINES.each do |line|
        it "must be true" do
          user_line = UserLine.new(line)
          user_line.valid?.must_equal true
        end
      end
    end

    describe "with invalid line" do
      INVALID_LINES.each do |line|
        let (:user_line) { UserLine.new(line)}
        it "must be false" do
          user_line.valid?.must_equal false
        end
      end
    end
  end
end
