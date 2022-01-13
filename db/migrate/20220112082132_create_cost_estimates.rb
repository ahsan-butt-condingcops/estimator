class CreateCostEstimates < ActiveRecord::Migration[6.0]
  def change
    create_table :cost_estimates do |t|
      t.string :patient_name
      t.datetime :date_of_appointment
      t.string :plan_name
      t.string :plan_type
      t.float :co_pay
      t.float :co_ins
      t.float :deductable_balance
      t.float :out_of_pocket_max_balance
      t.integer :visit_template_id
      t.integer :fee_schedule_id

      t.timestamps
    end
  end
end
