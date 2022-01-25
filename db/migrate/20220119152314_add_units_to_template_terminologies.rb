class AddUnitsToTemplateTerminologies < ActiveRecord::Migration[6.0]
  def change
    add_column :template_terminologies, :units, :integer
  end
end
