require 'minitest/autorun'
require_relative '../src/follower_map'

describe FollowerMap do
  describe '.from_list' do
    let (:follows) {[Follow.new('Rob', 'Zane'), Follow.new('Zane', 'Paul')]}

    it 'adds a follow for each item in the list' do
      map = FollowerMap.from_list(follows)

      map.broadcasters.count.must_equal 2
      map.followers_for('Rob').must_include 'Zane'
      map.followers_for('Zane').must_include 'Paul'
    end
  end

  describe '#followers_for' do
    let (:map) { FollowerMap.new }

    it 'returns all the followers for a given user sorted' do
      map.add_follow(Follow.new('Rob', 'Zane'))
      map.add_follow(Follow.new('Rob', 'Steve'))

      map.followers_for('Rob').must_equal ['Steve', 'Zane']
    end
  end

  describe '#add_follow' do
    let (:map) { FollowerMap.new }
    describe 'when the broadcaster does not exist' do
      let (:map) { FollowerMap.new }

      it 'creates the broadcaster' do
        map.add_follow(Follow.new('Rob', 'Steve'))

        map.broadcasters.must_include 'Rob'
      end
    end

    it 'adds the follower to the broadcaster only once' do
      map.add_follow(Follow.new('Rob', 'Steve'))
      map.add_follow(Follow.new('Rob', 'Steve'))

      map.followers_for('Rob').count('Steve').must_equal 1
    end
  end

  describe '#add_follows' do
    let (:map) { FollowerMap.new }
    let (:follows) {
      [
        Follow.new('Rob', 'Steve'),
        Follow.new('Steve', 'Rob'),
        Follow.new('Rob', 'Steve')
      ]
    }

    it 'adds each follow in the list without duplicates' do
      map.add_follows(follows)

      map.broadcasters.must_equal ['Rob', 'Steve']
      map.followers_for('Rob').must_equal ['Steve']
      map.followers_for('Steve').must_equal ['Rob']
    end
  end

  describe '#broadcasters' do
    let (:map) { FollowerMap.new }
    let (:follows) {
      [
        Follow.new('Rob', 'Steve'),
        Follow.new('Steve', 'Rob'),
        Follow.new('Zane', 'John')
      ]
    }

    it 'returns all known broadcasters in alphabetical order' do
      map.add_follows(follows)

      map.broadcasters.must_equal ['Rob', 'Steve', 'Zane']
    end
  end
end
