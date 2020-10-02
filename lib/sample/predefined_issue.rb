module Sample
  class PredefinedIssue
    def self.load
      issue_cateogry = ::IssueCategory.create(sector: 'commune', scorecard_category: 'community', year: 2020)

      list = [
        { content: 'តម្លៃនៃការផ្ដល់សេវា', audio: ''},
        { content: 'ល្បឿននៃការផ្ដល់សេវា', audio: ''},
        { content: 'សម្ដីសម្ដីរបស់មន្ត្រី', audio: ''},
        { content: 'ការជូនដំណឹងអំពីសេវា', audio: ''},
        { content: 'កន្លែងផ្ញើរម៉ូតូ', audio: ''},
      ]

      list.each do |issue|
        issue_cateogry.predefined_issues.create(issue)
      end
    end
  end
end
