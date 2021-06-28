# frozen_string_literal: true

module Sample
  class ScorecardReference
    def self.load(scorecard)
      scorecard.scorecard_references.create(kind: "swot_result", attachment: File.open(Rails.root.join("spec", "fixtures", "files", "reference_image.png")))
    end
  end
end
