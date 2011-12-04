class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :time_frame_id, :null => false
      t.string :kind, :null => false
      t.string :title, :null => false
      t.text :description
      t.float :value, :default => 0, :null => false
      t.date :bill_on
      t.boolean :auto_debit, :default => false, :null => false
      t.integer :credit_card_id
      t.boolean :done, :default => false, :null => false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
