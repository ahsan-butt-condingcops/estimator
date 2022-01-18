class CreateTerminologyFeeSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :terminology_fee_schedules do |t|
      t.integer :terminology_id
      t.integer :fee_schedule_id
      t.float :value

      t.timestamps
    end
  end
end
