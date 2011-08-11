require 'test_helper'

class UserPreferenceTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert UserPreference.new.valid?
  end
end
