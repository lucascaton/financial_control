class AddRecordKindColumnToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :record_kind, :string
  end
end
