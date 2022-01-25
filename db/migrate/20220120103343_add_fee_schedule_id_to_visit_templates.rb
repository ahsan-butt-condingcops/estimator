class AddFeeScheduleIdToVisitTemplates < ActiveRecord::Migration[6.0]
  def change
    add_column :visit_templates, :fee_schedule_id, :integer
  end
end
