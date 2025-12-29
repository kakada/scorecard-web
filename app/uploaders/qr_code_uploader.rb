# frozen_string_literal: true

class QrCodeUploader < CarrierWave::Uploader::Base
  # Use STORAGE_PROVIDER environment variable to dynamically select storage
  # Options: "Local" (default) or "AWS"
  if ENV["STORAGE_PROVIDER"].to_s.downcase == "aws"
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_allowlist
    %w[png]
  end

  # Override the filename of the uploaded files.
  def filename
    "qr_code.png" if original_filename
  end
end
