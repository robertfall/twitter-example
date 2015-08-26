require 'set'
require_relative 'follow'

class FollowerMap
  def self.from_list(follows)
    new.tap { |map|
      follows.each { |follow| map.add_follow(follow) }
    }
  end

  def initialize
    @follows = {}
  end

  def add_follow(follow)
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

  def followers_for(broadcaster)
    @follows.fetch(broadcaster, SortedSet.new).to_a
  end
end
