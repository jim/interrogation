require File.join(File.dirname(__FILE__), "test_helper")

class InterrogationTest < ActiveSupport::TestCase
  
  def setup
    @spoon = Spoon.new
  end
  
  test "method definition" do
    assert_true @spoon.methods.include?('in_scope?')
    assert_true @spoon.methods.include?('clean?')
    assert_true @spoon.methods.include?('soupy?')
  end
  
  test "dirty object detection" do
    assert_nothing_raised Interrogation::DirtyRecordError do
      @spoon.clean?
    end
    @spoon.contents = 'ice cream'
    assert_raise Interrogation::DirtyRecordError do
      @spoon.clean?
    end
  end
  
  test "interrogation methods" do
    soupy_spoon = Spoon.soupy.create!
    assert_true soupy_spoon.soupy?
    assert_false soupy_spoon.clean?
        
    clean_spoon = Spoon.create!
    assert_true clean_spoon.clean?
    assert_false clean_spoon.soupy?
    
  end
  
  test "range condition parsing" do
    big_spoon = Spoon.create!(:size => 20)
    assert_false big_spoon.bite_size?
  end
  
  test "database fallback" do
    crazy_spoon = Spoon.create(:contents => 'crazy')
    assert_true crazy_spoon.crazy?
  end
  
  test "invalid attribute parsing" do
    assert_raises Interrogation::AttributeNotFound do
      @spoon.salty?
    end
  end
  
end