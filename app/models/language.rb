class Language < ApplicationRecord
  mount_uploader :json_file, JsonFileUploader
end
