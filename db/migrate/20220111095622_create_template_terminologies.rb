class CreateTemplateTerminologies < ActiveRecord::Migration[6.0]
  def change
    create_table :template_terminologies do |t|
      t.integer :visit_template_id
      t.integer :terminology_id

      t.timestamps
    end
  end
end
