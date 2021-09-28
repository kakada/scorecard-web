class AddProgramUuidToReferenceTables < ActiveRecord::Migration[6.0]
  def up
    add_column :chat_groups, :program_uuid, :string
    add_column :contacts, :program_uuid, :string
    add_column :facilities, :program_uuid, :string
    add_column :languages, :program_uuid, :string
    add_column :local_ngos, :program_uuid, :string
    add_column :messages, :program_uuid, :string
    add_column :mobile_notifications, :program_uuid, :string
    add_column :mobile_tokens, :program_uuid, :string
    add_column :notifications, :program_uuid, :string
    add_column :pdf_templates, :program_uuid, :string
    add_column :rating_scales, :program_uuid, :string
    add_column :scorecards, :program_uuid, :string
    add_column :telegram_bots, :program_uuid, :string
    add_column :templates, :program_uuid, :string
    add_column :users, :program_uuid, :string
    add_column :activity_logs, :program_uuid, :string
    add_column :gf_dashboards, :program_uuid, :string

    Rake::Task["primary_school:migrate_location"].invoke
  end

  def down
    remove_column :chat_groups, :program_uuid
    remove_column :contacts, :program_uuid
    remove_column :facilities, :program_uuid
    remove_column :languages, :program_uuid
    remove_column :local_ngos, :program_uuid
    remove_column :messages, :program_uuid
    remove_column :mobile_notifications, :program_uuid
    remove_column :mobile_tokens, :program_uuid
    remove_column :notifications, :program_uuid
    remove_column :pdf_templates, :program_uuid
    remove_column :rating_scales, :program_uuid
    remove_column :scorecards, :program_uuid
    remove_column :telegram_bots, :program_uuid
    remove_column :templates, :program_uuid
    remove_column :users, :program_uuid
    remove_column :activity_logs, :program_uuid
    remove_column :gf_dashboards, :program_uuid
  end
end
