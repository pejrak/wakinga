require 'test_helper'

class MemorizationTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Memorization.new.valid?
  end
end
