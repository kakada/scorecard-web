class PdfTemplate < ApplicationRecord
  belongs_to :program

  has_rich_text :content
end
