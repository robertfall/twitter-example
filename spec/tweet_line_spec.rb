require 'minitest/autorun'
require_relative '../src/tweet_line'

VALID_LINES = ['Rob> This is a tweet!', 'Ward> H']
INVALID_LINES = ['Rob This is a tweet',
  'Rob>Also a tweet',
  'Rob > Also a tweet',
  'Just a body',
  'Rob> This tweet is going to exceed the maximum tweet length. ' +
    'It can be pretty tought to fit your thoughts into such a limited medium. ' +
    'Sometimes we just need more words to express ourselves.']

describe TweetLine do
  describe '#broadcaster' do
    describe 'with valid line' do
      it 'is the broadcaster of the tweet' do
        tweet = TweetLine.new(VALID_LINES.first)
        tweet.broadcaster.must_equal 'Rob'
      end
    end

    describe 'with invalid line' do
      it 'raises a TweetLineFormatError' do
        proc {
          TweetLine.new(INVALID_LINES.first).broadcaster
        }.must_raise TweetLineFormatError
      end
    end
  end

  describe '#body' do
    describe 'with valid line' do
      it 'is the body of the tweet' do
        tweet = TweetLine.new(VALID_LINES.first)
        tweet.body.must_equal 'This is a tweet!'
      end
    end

    describe 'with invalid line' do
      it 'raises a TweetLineFormatError' do
        proc {
          TweetLine.new(INVALID_LINES.first).body
        }.must_raise TweetLineFormatError
      end
    end
  end

  describe '#valid?' do
    VALID_LINES.each do |line|
      describe "with valid line '#{line}'" do
        let (:tweet_line) { TweetLine.new(line) }
        it 'must be true' do
          tweet_line.valid?.must_equal true
        end
      end
    end

    INVALID_LINES.each do |line|
      describe "with invalid line '#{line}'" do
        let (:tweet_line) { TweetLine.new(line) }
        it 'must be false' do
          tweet_line.valid?.must_equal false
        end
      end
    end
  end
end
