class AddSeveralIndexes < ActiveRecord::Migration
  def up
    add_index :entries, :time_frame_id
    add_index :entries, :credit_card_id
    add_index :memberships, :group_id
    add_index :memberships, :user_id
    add_index :time_frames, :group_id
  end

  def down
    remove_index :time_frames, :column => :group_id
    remove_index :memberships, :column => :user_id
    remove_index :memberships, :column => :group_id
    remove_index :entries, :column => :credit_card_id
    remove_index :entries, :column => :time_frame_id
  end
end
