require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

	test "should not save without content" do
		post = Post.new
		assert !post.save, "Saved the post without content"
	end
end
