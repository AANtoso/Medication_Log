class CreateMedications < ActiveRecord::Migration
  def change
    create_table :medications do |t|
      t.string :medication_name
      t.string :class
      t.string :indication
      t.string :dose
      t.string :frequency
      t.integer :user_id
    end
  end
end
