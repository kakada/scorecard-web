# frozen_string_literal: true

class JaapReferenceUploader < CarrierWave::Uploader::Base
  # File size limit in megabytes
  MAX_FILE_SIZE_MB = 5

  # Choose what kind of storage to use for this uploader:
  # Use STORAGE_PROVIDER environment variable to dynamically select storage
  # Options: "Local" (default) or "AWS"
  if ENV["STORAGE_PROVIDER"].to_s.downcase == "aws"
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add an allowlist of extensions which are allowed to be uploaded.
  # Allow images, PDF, and Excel files only
  def extension_allowlist
    %w[jpg jpeg png gif pdf xls xlsx]
  end

  # Add a content type allowlist to prevent malicious uploads
  def content_type_allowlist
    [
      # Images (Note: both .jpg and .jpeg files have MIME type 'image/jpeg')
      /image\/(jpeg|png|gif)/,
      # PDF
      "application/pdf",
      # Excel
      "application/vnd.ms-excel",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    ]
  end

  # Limit file size to 5MB
  def size_range
    0..(MAX_FILE_SIZE_MB.megabytes)
  end
end
