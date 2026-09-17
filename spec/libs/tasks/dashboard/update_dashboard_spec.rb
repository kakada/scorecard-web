# frozen_string_literal: true

require "rails_helper"
require "rake"

RSpec.describe "dashboard:update_dashboard rake task" do
  before(:all) do
    Rake::Task.clear
    Rails.application.load_tasks
  end

  let(:task_name) { "dashboard:update_dashboard" }

  before do
    # Rake tasks stay loaded across examples; re-enable so `invoke` runs again.
    Rake::Task[task_name].reenable

    allow($stdout).to receive(:puts)
  end

  subject(:run_task) { Rake::Task[task_name].invoke }

  context "with programs" do
    let!(:program_a) { create(:program, name: "Program A") }
    let!(:program_b) { create(:program, name: "Program B") }

    it "calls update_dashboard on every program" do
      call_count = 0
      allow_any_instance_of(Program).to receive(:update_dashboard) { call_count += 1 }

      run_task

      expect(call_count).to eq(2)
    end

    it "prints a confirmation message for each program" do
      allow_any_instance_of(Program).to receive(:update_dashboard)

      expect($stdout).to receive(:puts).with("Updated dashboard for program: #{program_a.name}")
      expect($stdout).to receive(:puts).with("Updated dashboard for program: #{program_b.name}")

      run_task
    end
  end

  context "with no programs" do
    it "does not raise" do
      expect { run_task }.not_to raise_error
    end
  end
end
