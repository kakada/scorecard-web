# frozen_string_literal: true

require "rails_helper"

RSpec.describe Scorecards::CallbackNotification do
  describe "#after_update, send notification" do
    let(:scorecard) { create(:scorecard) }
    let(:program) { scorecard.program }

    context "milestone downloaded" do
      let(:message) { create(:message, milestone: "downloaded", program: program) }

      before {
        message.create_telegram_notification
        message.create_email_notification

        allow_any_instance_of(Program).to receive(:telegram_bot_enabled).and_return(true)
        allow_any_instance_of(Program).to receive(:enable_email_notification?).and_return(true)
      }

      it { expect { scorecard.update(progress: "downloaded") }.to change(NotificationWorker.jobs, :size).by(2) }
    end
  end
end
