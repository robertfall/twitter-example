require 'set'
require './follow'

require 'minitest/autorun'

class FollowerMap
  def self.from_list(follows)

  end

  def initialize
    @follows = {}
  end

  def add_follow(follow)
    followers = @follows.fetch(follow.broadcaster, SortedSet.new)
    followers.add follow.subscriber
    @follows[follow.broadcaster] = followers
  end

  def broadcasters
    @follows.keys
  end

  def followers_for(broadcaster)
    @follows.fetch(broadcaster, SortedSet.new).to_a
  end
end

describe FollowerMap do
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
end
