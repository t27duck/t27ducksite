require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'name setter parameterizes attribute' do
    tag       = Tag.new
    tag.name  = ' TAG tag  1 '
    assert_equal 'tag-tag-1', tag.name

    tag = Tag.new(name: 'TAG')
    assert_equal 'tag', tag.name
  end
end
