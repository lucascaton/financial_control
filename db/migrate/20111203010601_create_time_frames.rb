class CreateTimeFrames < ActiveRecord::Migration
  def change
    create_table :time_frames do |t|
      t.integer :group_id
      t.date :start_on
      t.date :end_on

      t.timestamps
    end
  end
end
