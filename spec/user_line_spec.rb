require 'minitest/autorun'
require_relative '../src/user_line'

VALID_LINES = ['Rob follows John', 'Rob follows John, Rich, Toby, John']
INVALID_LINES = ['Rob', '', 'Rob > John', 'follows John', 'Rob follows']

describe UserLine do
  describe '#follows' do
    describe 'with valid line' do
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

    describe 'with invalid line' do
      it 'raises a UserLineFormatError' do
        proc {
          UserLine.new(INVALID_LINES.first).follows
        }.must_raise UserLineFormatError
      end
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
