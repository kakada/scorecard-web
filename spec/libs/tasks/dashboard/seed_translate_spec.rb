# frozen_string_literal: true

# spec/lib/tasks/dashboard/seed_translation_spec.rb

require "rails_helper"

require "rake"

RSpec.describe "dashboard:seed_translation rake task" do
  before(:all) do
    Rake::Task.clear
    Rails.application.load_tasks
  end

  let(:task_name) { "dashboard:seed_translation" }

  before do
    # Rake tasks stay loaded across examples; re-enable so `invoke` runs again.
    Rake::Task[task_name].reenable
  end

  subject(:run_task) { Rake::Task[task_name].invoke }

  let(:translations_dir) { Rails.root.join("db", "seeds", "translations") }

  let(:fixture_files) { [translations_dir.join("common.yml").to_s] }

  let(:fixture_data) do
    {
      "en" => {
        "greeting" => "Hello",
        "farewell" => "Goodbye"
      },
      "fr" => {
        "greeting" => "Bonjour"
      }
    }
  end

  before do
    allow(Dir).to receive(:glob)
      .with(translations_dir.join("*.yml"))
      .and_return(fixture_files)

    # Stub File.read per-file, and stub YAML.safe_load to key off the raw
    # content File.read returns for that file — mirrors what the task does.
    fixture_files.each do |path|
      allow(File).to receive(:read)
        .with(path)
        .and_return("raw yaml for #{path}")
    end

    allow(YAML).to receive(:safe_load).with(
      "raw yaml for #{fixture_files.first}",
      permitted_classes: [],
      permitted_symbols: [],
      aliases: false
    ).and_return(fixture_data)

    allow($stdout).to receive(:puts)
  end

  it "creates a Translation record for every key/locale pair in the seed file" do
    expect { run_task }.to change(Translation, :count).by(3)
  end

  it "sets the correct key, locale and label on each created record" do
    run_task

    expect(Translation.find_by(key: "greeting", locale: "en").label).to eq("Hello")
    expect(Translation.find_by(key: "farewell", locale: "en").label).to eq("Goodbye")
    expect(Translation.find_by(key: "greeting", locale: "fr").label).to eq("Bonjour")
  end

  context "when a translation already exists" do
    before do
      Translation.create!(
        key: "greeting",
        locale: "en",
        label: "Old value"
      )
    end

    it "updates the existing record instead of creating a duplicate" do
      expect { run_task }.to change(Translation, :count).by(2)

      expect(
        Translation.where(key: "greeting", locale: "en").count
      ).to eq(1)

      expect(
        Translation.find_by(key: "greeting", locale: "en").label
      ).to eq("Hello")
    end
  end

  context "with multiple seed files" do
    let(:fixture_files) do
      [
        translations_dir.join("common.yml").to_s,
        translations_dir.join("dashboard.yml").to_s
      ]
    end

    before do
      allow(YAML).to receive(:safe_load).with(
        "raw yaml for #{fixture_files[0]}",
        permitted_classes: [],
        permitted_symbols: [],
        aliases: false
      ).and_return(
        {
          "en" => {
            "greeting" => "Hello"
          }
        }
      )

      allow(YAML).to receive(:safe_load).with(
        "raw yaml for #{fixture_files[1]}",
        permitted_classes: [],
        permitted_symbols: [],
        aliases: false
      ).and_return(
        {
          "en" => {
            "widget_title" => "Widgets",
            "dashboard_title" => "Dashboard"
          },
          "fr" => {
            "widget_title" => "Widgets"
          }
        }
      )
    end

    it "seeds translations from every matched file" do
      run_task

      expect(
        Translation.find_by(key: "greeting", locale: "en").label
      ).to eq("Hello")

      expect(
        Translation.find_by(key: "widget_title", locale: "en").label
      ).to eq("Widgets")

      expect(
        Translation.find_by(key: "dashboard_title", locale: "en").label
      ).to eq("Dashboard")

      expect(
        Translation.find_by(key: "widget_title", locale: "fr").label
      ).to eq("Widgets")
    end

    it "prints the total number of keys for each file" do
      expect($stdout).to receive(:puts).with("\ncommon.yml")
      expect($stdout).to receive(:puts).with("  Seeded: 1 keys for en")

      expect($stdout).to receive(:puts).with("\ndashboard.yml")
      expect($stdout).to receive(:puts).with("  Seeded: 2 keys for en")
      expect($stdout).to receive(:puts).with("  Seeded: 1 keys for fr")

      run_task
    end
  end

  context "when a record fails validation" do
    before do
      allow_any_instance_of(Translation)
        .to receive(:save!)
        .and_raise(ActiveRecord::RecordInvalid)
    end

    it "raises and halts the task" do
      expect { run_task }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "when the task finishes" do
    it "prints the total translation count" do
      expect($stdout)
        .to receive(:puts)
        .with(/Seeded:/)

      run_task
    end
  end

  context "when no seed files are found" do
    let(:fixture_files) { [] }

    it "does not raise and does not create any translations" do
      expect { run_task }.not_to change(Translation, :count)
    end
  end

  context "when a seed file contains disallowed YAML (symbols/aliases)" do
    it "lets Psych::DisallowedClass / aliasing errors propagate rather than swallowing them" do
      allow(File).to receive(:read)
        .with(fixture_files.first)
        .and_return(":foo: bar")

      allow(YAML).to receive(:safe_load).with(
        ":foo: bar",
        permitted_classes: [],
        permitted_symbols: [],
        aliases: false
      ).and_call_original

      expect { run_task }.to raise_error(Psych::DisallowedClass)
    end
  end
end
