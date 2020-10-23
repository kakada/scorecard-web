# frozen_string_literal: true

module Sample
  class Rating
    def self.load
      scorecard = ::Scorecard.first
      return if scorecard.nil?

      scorecard.number_of_participant.to_i.times do |i|
        scorecard.voting_indicators.each do |indi|
          scorecard.ratings.create(
            voting_indicator_id: indi.id,
            score: rand(1..5)
          )
        end
      end

      update_voting_indicator_median(scorecard)
    end

    private
      def self.update_voting_indicator_median(scorecard)
        scorecard.voting_indicators.each do |indi|
          indi_scores = ::Rating.where(voting_indicator_id: indi.id).pluck(:score)
          indi.update(median: median(indi_scores).ceil)
        end
      end

      def self.median(array, already_sorted = false)
        return nil if array.empty?
        array = array.sort unless already_sorted
        m_pos = array.size / 2
        array.size % 2 == 1 ? array[m_pos] : mean(array[m_pos-1..m_pos])
      end

      def self.mean(array)
        array.inject(0) { |sum, x| sum + x } / array.size.to_f
      end
  end
end
