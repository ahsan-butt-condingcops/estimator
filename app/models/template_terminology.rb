class TemplateTerminology < ApplicationRecord
  has_one :visit_template
  has_one :terminology
end
