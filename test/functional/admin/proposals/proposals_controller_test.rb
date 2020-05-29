require 'test_helper'

class Admin::Proposals::ProposalsControllerTest < ActionController::TestCase
  setup do
    @call = FactoryBot.create(:proposal_call, question_count: 5, submission_deadline: DateTime.now.advance(days: 5))

    @admin = users(:admin)
    sign_in @admin
  end

  test 'should get index' do
    FactoryBot.create_list(:proposal, 10, call: @call)

    get :index, params: { call_id: @call.id }
    assert_response :success
    assert_not_nil assigns(:proposals)
  end

  test 'should show proposal' do
    sign_out @admin
    proposal = FactoryBot.create(:proposal, call: @call)
    proposal.users.first.add_role :admin
    sign_in proposal.users.first

    get :show, params: { call_id: @call.id, id: proposal }
    assert_response :success
  end

  test 'someone on the proposal can see debt status' do
    sign_out @admin

    proposal = FactoryBot.create(:proposal, call: @call)
    user = proposal.users.first
    user.add_role(:member)
    debtor = proposal.users.last

    assert_not_nil user
    assert_not_equal user, debtor, 'The debtor is the same as the current user. This means the test will not be accurate. Did you add more than 1 person to the proposal?'

    FactoryBot.create(:maintenance_debt, user: debtor, due_by: Date.today.advance(days: -1))

    sign_in user

    get :show, params: { call_id: @call.id, id: proposal }

    assert_response :success

    assert_match '<a class="label label-important"', response.body
    assert_match 'In maintenance Debt', response.body

    assert_match 'class="label label-danger">Has Debtors</span>', response.body, 'The Has Debtors label is absent. Are you sure the label generation did not change? Are you sure one of the users is actually in debt (most likely because there is a maintenance debt label)?'
  end

  test 'should get new' do
    get :new, params: { call_id: @call.id }
    assert_response :success
  end

  test 'should not get new after the submission deadline' do
    @call.update_attribute(:submission_deadline, DateTime.now.advance(hours: -1))
    get :new, params: { call_id: @call.id }

    assert_includes flash[:error], "The submission deadline for #{@call.name} has been passed"
    assert_redirected_to admin_proposals_call_proposals_path(@call)
  end

  test 'should create proposal' do
    # This mess is to force the inclusion of team_member attributes.
    # You cannot just use attributes_for, and team_work does not actually get an user linked when using build.
    proposal = FactoryBot.build(:proposal)

    attributes = proposal.attributes.except('id', 'call_id', 'created_at', 'updated_at')
    attributes[:team_members_attributes] = {}

    proposal.team_members.each_with_index do |team_member, index|
      team_member_attributes = team_member.attributes.except('id', 'teamwork_id', 'teamwork_type', 'created_at', 'updated_at')
      team_member_attributes[:user_id] = FactoryBot.create(:member).id
      attributes[:team_members_attributes][index] = team_member_attributes
    end

    assert_difference('Admin::Proposals::Proposal.count') do
      post :create, params: { call_id: @call.id, admin_proposals_proposal: attributes }
    end

    assert_redirected_to admin_proposals_call_proposal_path(@call, assigns(:proposal))
  end

  test 'should not create invalid proposal' do
    attributes = FactoryBot.attributes_for(:proposal, show_title: nil)

    assert_no_difference('Admin::Proposals::Proposal.count') do
      post :create, params: { call_id: @call.id, admin_proposals_proposal: attributes }
    end

    assert_response :unprocessable_entity
  end

  test 'should not create after the submission deadline' do
    @call.update_attribute(:submission_deadline, DateTime.now.advance(hours: -1))
    attributes = FactoryBot.attributes_for(:proposal)

    assert_no_difference('Admin::Proposals::Proposal.count') do
      post :create, params: { call_id: @call.id, admin_proposals_proposal: attributes }
    end

    assert_includes flash[:error], "The submission deadline for #{@call.name} has been passed"
    assert_redirected_to admin_proposals_call_proposals_path(@call)
  end

  test 'should get edit' do
    @call.update_attribute(:submission_deadline, DateTime.now.advance(days: -1))
    proposal = FactoryBot.create(:proposal, call: @call)

    get :edit, params: { call_id: @call.id, id: proposal }
    assert_response :success
  end

  test 'should update proposal' do
    sign_out @admin
    proposal = FactoryBot.create(:proposal, call: @call)
    proposal.users.first.add_role :admin
    sign_in proposal.users.first

    attributes = FactoryBot.attributes_for(:proposal)

    put :update, params: { call_id: @call.id, id: proposal, admin_proposals_proposal: attributes }

    assert_not_nil assigns(:proposal), 'The update function did not set a proposal. There is probably something wrong with the authentication.'

    assert_redirected_to admin_proposals_call_proposal_path(@call.id, assigns(:proposal))
  end

  test 'should not update invalid proposal' do
    sign_out @admin

    proposal = FactoryBot.create(:proposal, call: @call)
    proposal.users.first.add_role :admin
    sign_in proposal.users.first

    attributes = FactoryBot.attributes_for(:proposal, publicity_text: nil)

    put :update, params: { call_id: @call.id, id: proposal, admin_proposals_proposal: attributes }

    assert proposal.show_title, assigns(:proposal).show_title

    assert_response :unprocessable_entity
  end

  test 'should destroy admin_proposals_proposal' do
    proposal = FactoryBot.create(:proposal, call: @call)

    assert_difference('Admin::Proposals::Proposal.count', -1) do
      delete :destroy, params: { call_id: @call.id, id: proposal }
    end

    assert_redirected_to admin_proposals_call_proposals_url(@call)
  end

  test 'approve' do
    @call.update_attribute(:submission_deadline, DateTime.now.advance(days: -1))
    proposal = FactoryBot.create(:proposal, call: @call)

    put :approve, params: { call_id: @call.id, id: proposal.id }

    assert assigns(:proposal).approved
    assert_redirected_to admin_proposals_call_proposal_path(@call, proposal)
    assert_equal "#{proposal.show_title} has been marked as approved", flash[:success]
  end

  test 'reject' do
    @call.update_attribute(:submission_deadline, DateTime.now.advance(days: -1))
    proposal = FactoryBot.create(:proposal, call: @call)

    put :reject, params: { call_id: @call.id, id: proposal.id }

    assert_not assigns(:proposal).approved
    assert_redirected_to admin_proposals_call_proposal_path(@call, proposal)
    assert_equal "#{proposal.show_title} has been marked as rejected", flash[:success]
  end

  test 'convert' do
    @call.update_attribute(:submission_deadline, DateTime.now.advance(days: -1))
    proposal = FactoryBot.create(:proposal, call: @call, successful: true)

    assert_difference 'Show.count' do
      put :convert, params: { call_id: @call.id, id: proposal.id }
    end

    assert Show.where(name: proposal.show_title).any?
    assert_redirected_to admin_proposals_call_proposal_path(@call, proposal)
    assert_includes flash[:notice], 'is queued to be converted'
  end

  test 'should not convert when the proposal has not been approved' do
    @call.update_attribute(:submission_deadline, DateTime.now.advance(days: -1))
    proposal = FactoryBot.create(:proposal, call: @call)

    assert_no_difference 'Show.count' do
      put :convert, params: { call_id: @call.id, id: proposal.id }
    end

    assert_redirected_to admin_proposals_call_proposal_path(@call, proposal)
    assert_equal ['This proposal was not successful'], flash[:error]
  end

  test 'about' do
    get :about

    assert_response :success
  end
end
