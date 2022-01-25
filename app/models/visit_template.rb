class VisitTemplate < ApplicationRecord
  has_many :template_terminologies
  accepts_nested_attributes_for :template_terminologies
end
