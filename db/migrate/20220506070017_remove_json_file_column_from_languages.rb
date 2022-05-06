class RemoveJsonFileColumnFromLanguages < ActiveRecord::Migration[6.1]
  def change
    remove_column :languages, :json_file
  end
end
