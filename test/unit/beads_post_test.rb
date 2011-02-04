require 'test_helper'

class BeadsPostTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert BeadsPost.new.valid?
  end
end
