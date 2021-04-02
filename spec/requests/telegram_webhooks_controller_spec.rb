# frozen_string_literal: true

require "rails_helper"
require "telegram/bot/rspec/integration/rails"

RSpec.describe TelegramWebhooksController, telegram_bot: :rails do
  let!(:telegram_bot) { create(:telegram_bot, token: "952424300:token") }
  let(:program)   { telegram_bot.program }
  let(:chat_group) { ChatGroup.first }

  context "add bot to group" do
    let(:new_chat_member_param) {
      {
        "from"=>{ "id"=>123, "is_bot"=>false, "first_name"=>"Sokly", "last_name"=>"Heng", "language_code"=>"en" },
        "chat"=>{ "id"=>-1001416771311, "title"=>"mygroup", "type"=>"supergroup" },
        "new_chat_member"=>{ "id"=>952424300, "is_bot"=>true, "first_name"=>"scorecard_bot", "username"=>"scorecard_care_bot" }
      }
    }

    before {
      dispatch_message("", new_chat_member_param)
    }

    it { expect(ChatGroup.count).to eq(1) }
    it { expect(chat_group.actived).to eq(true) }
    it { expect(chat_group.title).to eq("mygroup") }
    it { expect(chat_group.chat_type).to eq("supergroup") }
  end

  context "remove bot from group" do
    let(:left_chat_member_param) {
      {
        "from"=>{ "id"=>123, "is_bot"=>false, "first_name"=>"Sokly", "last_name"=>"Heng", "language_code"=>"en" },
        "chat"=>{ "id"=>111, "title"=>"mygroup", "type"=>"group" },
        "left_chat_member"=>{ "id"=>952424300, "is_bot"=>true, "first_name"=>"scorecard_bot", "username"=>"scorecard_care_bot" }
      }
    }

    before {
      create(:chat_group, :telegram, program: program)
      dispatch_message("", left_chat_member_param)
    }

    it { expect(ChatGroup.count).to eq(1) }
    it { expect(chat_group.actived).to eq(false) }
    it { expect(chat_group.title).to eq("mygroup") }
    it { expect(chat_group.chat_type).to eq("group") }
  end

  context "migrate to supergroup" do
    let(:migrate_to_chat_param) {
      {
        "from"=>{ "id"=>787037629, "is_bot"=>false, "first_name"=>"Sokly", "last_name"=>"Heng" },
        "chat"=>{ "id"=>111, "title"=>"test-group3", "type"=>"group", "all_members_are_administrators"=>false },
        "migrate_to_chat_id"=>-1001441058136
      }
    }

    before {
      create(:chat_group, :telegram, program: program)
      dispatch_message("", migrate_to_chat_param)
    }

    it { expect(ChatGroup.count).to eq(1) }
    it { expect(chat_group.chat_id).to eq("-1001441058136") }
    it { expect(chat_group.chat_type).to eq("supergroup") }
  end
end
