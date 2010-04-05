require 'test_helper'

class EvolutionPriorityTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert EvolutionPriority.new.valid?
  end
end
