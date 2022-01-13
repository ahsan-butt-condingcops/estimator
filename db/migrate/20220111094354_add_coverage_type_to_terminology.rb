class AddCoverageTypeToTerminology < ActiveRecord::Migration[6.0]
  def change
    add_column :terminologies, :coverage_type, :string
  end
end
