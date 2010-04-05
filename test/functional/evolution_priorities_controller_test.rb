require 'test_helper'

class EvolutionPrioritiesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => EvolutionPriority.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    EvolutionPriority.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    EvolutionPriority.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to evolution_priority_url(assigns(:evolution_priority))
  end
  
  def test_edit
    get :edit, :id => EvolutionPriority.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    EvolutionPriority.any_instance.stubs(:valid?).returns(false)
    put :update, :id => EvolutionPriority.first
    assert_template 'edit'
  end
  
  def test_update_valid
    EvolutionPriority.any_instance.stubs(:valid?).returns(true)
    put :update, :id => EvolutionPriority.first
    assert_redirected_to evolution_priority_url(assigns(:evolution_priority))
  end
  
  def test_destroy
    evolution_priority = EvolutionPriority.first
    delete :destroy, :id => evolution_priority
    assert_redirected_to evolution_priorities_url
    assert !EvolutionPriority.exists?(evolution_priority.id)
  end
end
