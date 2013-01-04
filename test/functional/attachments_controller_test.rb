require 'test_helper'

class AttachmentsControllerTest < ActionController::TestCase

  test "should get show" do
    eb = admin_editable_blocks(:one)
    attachment = FactoryGirl.create(:attachment, editable_block: eb)

    get :show, slug: attachment.name
    assert_response :success
  end

end