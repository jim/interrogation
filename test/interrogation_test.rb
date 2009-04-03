require File.join(File.dirname(__FILE__), "test_helper")

class InterrogationTest < ActiveSupport::TestCase
  
  def setup
    @spoon = Spoon.new
  end
  
  test "method definition" do
    assert @spoon.methods.include?('in_scope?')
    assert @spoon.methods.include?('clean?')
    assert @spoon.methods.include?('soupy?')
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
    assert soupy_spoon.soupy?
    assert_false soupy_spoon.clean?
        
    clean_spoon = Spoon.create!
    assert clean_spoon.clean?
    assert_false clean_spoon.soupy?
    
  end
  
  test "range condition parsing" do
    
    big_spoon = Spoon.create!(:size => 20)
    assert_false big_spoon.bite_size?
    
  end
  
end