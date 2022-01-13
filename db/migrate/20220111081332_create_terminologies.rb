class CreateTerminologies < ActiveRecord::Migration[6.0]
  def change
    create_table :terminologies do |t|
      t.string :code
      t.string :description
      t.string :modifier
      t.float :charge

      t.timestamps
    end
  end
end
