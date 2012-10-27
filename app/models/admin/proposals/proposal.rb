class Admin::Proposals::Proposal < ActiveRecord::Base
  belongs_to :call, :class_name => "Admin::Proposals::Call"
  
  has_many :answers, :class_name => "Admin::Proposals::Answer"
  has_many :team_members
  has_many :users, :through => :team_members
  
  accepts_nested_attributes_for :answers, :team_members
  attr_accessible :proposal_text, :publicity_text, :show_title, :answers, :answers_attributes, :team_members, :team_members_attributes
end
