class RenameMembershipsTable < ActiveRecord::Migration
  def up
    rename_table :partnerships, :memberships
  end

  def down
    rename_table :memberships, :partnerships
  end
end
