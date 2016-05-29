require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:one)
  end

  test '#publish is true if published_at is set' do
    @post.published_at = nil
    refute @post.publish

    @post.published_at = Time.now.utc
    assert @post.publish
  end

  test '#publish= sets published_at with a truthy value' do
    {
      'true'  => true,
      true    => true,
      '1'     => true,
      1       => true,
      'false' => false,
      false   => false,
      '0'     => false,
      0       => false
    }.each do |input, expected|
      @post.publish = input
      assert_equal @post.published_at.present?, expected
    end
  end
end
