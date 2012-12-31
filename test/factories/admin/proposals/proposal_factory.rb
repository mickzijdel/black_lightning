# == Schema Information
#
# Table name: admin_proposals_proposals
#
# *id*::             <tt>integer, not null, primary key</tt>
# *call_id*::        <tt>integer</tt>
# *show_title*::     <tt>string(255)</tt>
# *publicity_text*:: <tt>text</tt>
# *proposal_text*::  <tt>text</tt>
# *created_at*::     <tt>datetime, not null</tt>
# *updated_at*::     <tt>datetime, not null</tt>
# *late*::           <tt>boolean</tt>
# *approved*::       <tt>boolean</tt>
# *successful*::     <tt>boolean</tt>
#--
# == Schema Information End
#++

FactoryGirl.define do
  factory :proposal, class: Admin::Proposals::Proposal do
    show_title     { generate(:random_string) }
    proposal_text  { generate(:random_text) }
    publicity_text { generate(:random_text) }
    approved       { [true, nil, false].sample }

    after(:build) do |proposal, evaluator|
      proposal.team_members << FactoryGirl.build_list(:team_member, 5, teamwork: proposal)
    end

    after(:create) do |proposal, evaluator|
      proposal.call.questions.each do |q|
        create(:answer, question: q, answerable: proposal)
      end
    end
  end
end