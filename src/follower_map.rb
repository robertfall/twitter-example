require 'set'
require_relative 'follow'

class FollowerMap
  def self.from_list(follows)
    new.tap { |map| map.add_follows(follows) }
  end

  def initialize
    @follows = {}
    @users = SortedSet.new
  end

  def add_follow(follow)
    @users.add(follow.broadcaster)
    @users.add(follow.subscriber)

    followers = @follows.fetch(follow.broadcaster, SortedSet.new)
    followers.add follow.subscriber
    @follows[follow.broadcaster] = followers
  end

  def add_follows(follows)
    follows.each do |follow|
      add_follow(follow)
    end
  end

  def broadcasters
    @follows.keys
  end

  def users
    @users.to_a
  end

  def followers_for(broadcaster)
    @follows.fetch(broadcaster, SortedSet.new).to_a
  end
end
