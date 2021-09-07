require 'rails_helper'
RSpec.describe ActivityLogsWorker, type: :worker do
  it { is_expected.to be_processed_in :default }
  it { is_expected.to be_retryable true }

  it 'enqueues another awesome job' do
    ActivityLogsWorker.perform_async

    expect(ActivityLogsWorker).to have_enqueued_sidekiq_job
  end
end
