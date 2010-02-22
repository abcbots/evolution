require 'test_helper'

class EvolutionTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Evolution.new.valid?
  end
end
