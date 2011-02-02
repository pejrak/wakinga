require 'test_helper'

class EnrollmentTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Enrollment.new.valid?
  end
end
