class AddUniqueIndexToFieldsName < ActiveRecord::Migration[8.0]
  def change
    add_index :fields, :name, unique: true
  end
end
