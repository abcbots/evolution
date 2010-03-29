require 'test_helper'

class EvolutionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Evolution.first
    assert_template 'show'
  end

  def test_destroy
    evolution = Evolution.first
    delete :destroy, :id => evolution
    assert_redirected_to evolutions_url
    assert !Evolution.exists?(evolution.id)
  end
end
