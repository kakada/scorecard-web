# encoding: utf-8

##
# Backup Generated: my_backup
# Once configured, you can run the backup with the following command:
#
# $ backup perform -t my_backup [-c <path_to_configuration_file>]
#
Backup::Model.new(:db_backup, 'Backup scorecards database') do
  ##
  # Split [Splitter]
  #
  # Split the backup file in to chunks of 250 megabytes
  # if the backup file size exceeds 250 megabytes
  #
  split_into_chunks_of 250
  ##
  # Archive [Archive]
  #
  # Adding a file or directory (including sub-directories):
  #   archive.add "/path/to/a/file.rb"
  #   archive.add "/path/to/a/directory/"
  #
  # Excluding a file or directory (including sub-directories):
  #   archive.exclude "/path/to/an/excluded_file.rb"
  #   archive.exclude "/path/to/an/excluded_directory
  #
  # By default, relative paths will be relative to the directory
  # where `backup perform` is executed, and they will be expanded
  # to the root of the filesystem when added to the archive.
  #
  # If a `root` path is set, relative paths will be relative to the
  # given `root` path and will not be expanded when added to the archive.
  #
  #   archive.root '/path/to/archive/root'
  #
  # For more details, please see:
  # https://github.com/meskyanichi/backup/wiki/Archives
  #
  # archive :my_archive do |archive|
  #   # Run the `tar` command using `sudo`
  #   # archive.use_sudo
  #   archive.add "/path/to/a/file.rb"
  #   archive.add "/path/to/a/folder/"
  #   archive.exclude "/path/to/a/excluded_file.rb"
  #   archive.exclude "/path/to/a/excluded_folder"
  # end

  database PostgreSQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = ENV.fetch('DB_NAME') { 'csc_web_development' }
    db.username           = ENV.fetch('DB_USER') { 'postgres' }
    db.password           = ENV.fetch('DB_PWD') { '' }
    db.host               = ENV.fetch('DB_HOST') { 'db' }
    db.port               = ENV.fetch('DB_PORT') { 5432 }
    # db.socket             = "/tmp/pg.sock"
    # When dumping all databases, `skip_tables` and `only_tables` are ignored.
    # db.skip_tables        = ['skip', 'these', 'tables']
    # db.only_tables        = ['only', 'these' 'tables']
    db.additional_options = []
  end

  if ENV['STORAGE_TYPE'] == "Local"
    ##
    # Local (Copy) [Storage]
    #
    store_with Local do |local|
      local.path       = "~/backups/"
      local.keep       = 5
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

  ##
  # Mail [Notifier]
  #
  # The default delivery method for Mail Notifiers is 'SMTP'.
  # See the Wiki for other delivery options.
  # https://github.com/meskyanichi/backup/wiki/Notifiers
  #
  # notify_by Mail do |mail|
  #   mail.on_success           = true
  #   mail.on_warning           = true
  #   mail.on_failure           = true

  #   mail.from                 = "sender@email.com"
  #   mail.to                   = "receiver@email.com"
  #   mail.address              = "smtp.gmail.com"
  #   mail.port                 = 587
  #   mail.domain               = "your.host.name"
  #   mail.user_name            = "sender@email.com"
  #   mail.password             = "my_password"
  #   mail.authentication       = "plain"
  #   mail.encryption           = :starttls
  # end

end
