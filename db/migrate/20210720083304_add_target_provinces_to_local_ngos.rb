class AddTargetProvincesToLocalNgos < ActiveRecord::Migration[6.0]
  def up
    add_column :local_ngos, :target_provinces, :string

    Rake::Task["local_ngo:migrate_target_provinces"].invoke
  end

  def down
    remove_column :local_ngos
  end
end
