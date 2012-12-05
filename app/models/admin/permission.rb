class Admin::Permission < ActiveRecord::Base
  has_and_belongs_to_many :roles

  attr_accessible :action, :subject_class
end