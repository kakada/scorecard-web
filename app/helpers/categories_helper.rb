# frozen_string_literal: true

module CategoriesHelper
  def steps
    [
      {
        name: "province",
        children: [
          {
            name: "district",
            children: [
              {
                name: "commune",
                children: []
              }
            ]
          }
        ]
      }
    ]
  end
end
