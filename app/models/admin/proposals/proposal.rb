class Admin::Proposals::Proposal < ActiveRecord::Base
  belongs_to :call, :class_name => "Admin::Proposals::Call"
  
  has_many :answers, :class_name => "Admin::Proposals::Answer"
  has_many :team_members
  has_many :users, :through => :team_members
  
  accepts_nested_attributes_for :answers, :team_members
  attr_accessible :budget_admin, :budget_contingency, :budget_costume, :budget_eutc, :budget_other_sources, :budget_props, :budget_publiciy, :budget_royalties, :budget_set, :budget_tech, :cast_female, :cast_male, :proposal_text, :publicity_text, :running_time, :show_title, :answers, :answers_attributes, :team_members, :team_members_attributes
end
