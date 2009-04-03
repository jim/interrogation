require File.join(File.dirname(__FILE__), "test_helper")

class InterrogationTest < ActiveSupport::TestCase
  
  def setup
    @spatula = Spatula.new
  end
  
  test "method definition" do
    assert @spatula.methods.include?('clean?')
    assert @spatula.methods.include?('soupy?')
  end
  
  test "dirty object detection" do
    assert_nothing_raised Interrogation::DirtyRecordError do
      @spatula.clean?
    end
    @spatula.contents = 'ice cream'
    assert_raise Interrogation::DirtyRecordError do
      @spatula.clean?
    end
  end
  
  test "interrogation methods" do
    soupy_spatula = Spatula.soupy.create!
    assert soupy_spatula.soupy?
  end
  
end