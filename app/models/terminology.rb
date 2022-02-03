class Terminology < ApplicationRecord
  has_many :terminology_fee_schedules

  validates :code, presence: true
end
