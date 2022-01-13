json.extract! cost_estimate, :id, :patient_name, :date_of_appointment, :plan_name, :plan_type, :co_pay, :co_ins, :deductable_balance, :out_of_pocket_max_balance, :visit_template_id, :fee_schedule_id, :created_at, :updated_at
json.url cost_estimate_url(cost_estimate, format: :json)
