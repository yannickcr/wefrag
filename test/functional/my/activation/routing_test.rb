require File.dirname(__FILE__) + '/../../../test_helper'

class My::ActivationRoutingTest < ActionController::TestCase
  tests My::ActivationController

  def setup
    @code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end 

  test 'route to :show' do
    assert_routing "/my/activation/#{@code}", { :controller => 'my/activation', :action => 'show', :id => @code }
  end

  test 'helper to :show' do
    assert_equal "/my/activation/#{@code}", my_activation_path(@code)
  end
end

