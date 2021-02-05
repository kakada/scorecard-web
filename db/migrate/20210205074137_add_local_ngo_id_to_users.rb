class AddLocalNgoIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :local_ngo_id, :integer
  end
end
