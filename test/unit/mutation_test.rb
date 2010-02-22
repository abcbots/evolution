require 'test_helper'

class MutationTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Mutation.new.valid?
  end
end
