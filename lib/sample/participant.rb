# frozen_string_literal: true

module Sample
  class Participant
    def self.load(scorecard)
      scorecard.number_of_female.to_i.times do |i|
        create_participant(scorecard, "female")
      end

      other = scorecard.number_of_participant - scorecard.number_of_female
      other.times do |i|
        create_participant(scorecard)
      end
    end

    private
      def self.create_participant(scorecard, gender = nil)
        scorecard.participants.create(
          age: rand(20..65),
          gender: gender || %w(male other).sample,
          disability: [true, false].sample,
          minority: [true, false].sample,
          poor_card: [true, false].sample,
          youth: [true, false].sample
        )
      end
  end
end
