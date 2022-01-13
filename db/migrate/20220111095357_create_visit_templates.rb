class CreateVisitTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :visit_templates do |t|
      t.string :name

      t.timestamps
    end
  end
end
