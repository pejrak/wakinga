require 'test_helper'

class TrustTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Trust.new.valid?
  end
end
