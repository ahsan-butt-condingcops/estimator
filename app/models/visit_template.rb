class VisitTemplate < ApplicationRecord
  has_many :template_terminologies
  accepts_nested_attributes_for :template_terminologies

  validates :name, presence: true
  validates :fee_schedule_id, presence: true
end
