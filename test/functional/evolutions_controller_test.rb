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
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Evolution.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Evolution.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to evolution_url(assigns(:evolution))
  end
  
  def test_edit
    get :edit, :id => Evolution.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Evolution.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Evolution.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Evolution.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Evolution.first
    assert_redirected_to evolution_url(assigns(:evolution))
  end
  
  def test_destroy
    evolution = Evolution.first
    delete :destroy, :id => evolution
    assert_redirected_to evolutions_url
    assert !Evolution.exists?(evolution.id)
  end
end
