# frozen_string_literal: true
# encoding: utf-8

##
# Backup Generated: db_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t db_backup [-c <path_to_configuration_file>]
#
# For more information about Backup's components, see the documentation at:
# http://backup.github.io/backup
#
Model.new(:db_backup, "Backup scorecards database") do
  database PostgreSQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = ENV.fetch("DB_NAME") { "csc_web_development" }
    db.username           = ENV.fetch("DB_USER") { "postgres" }
    db.password           = ENV.fetch("DB_PWD") { "" }
    db.host               = ENV.fetch("DB_HOST") { "db" }
    db.port               = ENV.fetch("DB_PORT") { 5432 }
    # db.socket             = "/tmp/pg.sock"
    # When dumping all databases, `skip_tables` and `only_tables` are ignored.
    # db.skip_tables        = ['skip', 'these', 'tables']
    # db.only_tables        = ['only', 'these' 'tables']
    db.additional_options = []
  end

  if ENV["STORAGE_TYPE"] == "Local"
    ##
    # Local (Copy) [Storage]
    #
    store_with Local do |local|
      local.path       = "~/backups/"
      local.keep       = 5
      # local.keep       = Time.now - 2592000 # Remove all backups older than 1 month.
    end
  else
    ##
    # AWS3 [Storage]
    #
    store_with S3 do |s3|
      # AWS Credentials
      s3.access_key_id     = ENV["AWS_ACCESS_KEY_ID"]
      s3.secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
      # Or, to use a IAM Profile:
      # s3.use_iam_profile = true

      s3.region             = ENV["AWS_REGION"]
      s3.bucket             = ENV["AWS_NAME_OF_DB_BUCKET"]
      s3.path               = ENV["AWS_PATH_TO_DB_BACKUP"]
    end
  end

  ##
  # Gzip [Compressor]
  #
  compress_with Gzip
end
