require 'test_helper'

class MutationsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Mutation.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Mutation.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Mutation.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to mutation_url(assigns(:mutation))
  end
  
  def test_edit
    get :edit, :id => Mutation.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Mutation.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Mutation.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Mutation.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Mutation.first
    assert_redirected_to mutation_url(assigns(:mutation))
  end
  
  def test_destroy
    mutation = Mutation.first
    delete :destroy, :id => mutation
    assert_redirected_to mutations_url
    assert !Mutation.exists?(mutation.id)
  end
end
