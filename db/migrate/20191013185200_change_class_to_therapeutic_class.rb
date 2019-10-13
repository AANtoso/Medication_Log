class ChangeClassToTherapeuticClass < ActiveRecord::Migration
  def change
    rename_column :medications, :class, :therapeutic_class
  end
end
