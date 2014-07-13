require 'active_model'

module DirManifest
  class Verifier < Digester
    include ActiveModel::Validations

    validate :digest_file_exists?,       if: :still_valid?
    validate :digest_file_deserialized?, if: :still_valid?
    validate :digest_file_correct_keys?, if: :still_valid?
    validate :validate_filenames,        if: :still_valid?
    validate :validate_digests,          if: :still_valid?

    def digest_file_exists?
      unless File.exists? digest_file_name
        errors.add :base, "No #{DirManifest::Config.digest_file} file found in #{path}"
      end
    end

    def digest_file_deserialized?
      @deserialized = YAML.load_file digest_file_name
    rescue
      errors.add :base, "Unable to parse #{digest_file_name}"
    end

    def digest_file_correct_keys?
      unless @deserialized.keys.sort == %w[generated algorithm files].sort
        errors.add :base, "Unexpected keys in digest file"
      end
    end

    def validate_filenames
      digest_files = @deserialized['files'].map { |f| f['filename'] }.sort
      actual_files = entries.sort
      message      = []
      unless (diff = digest_files - actual_files).empty?
        message << "Extra files in digest: #{diff.inspect}"
      end
      unless (diff = actual_files - digest_files).empty?
        message << "Extra files in directory: #{diff.inspect}"
      end
      unless message.empty?
        errors.add :base, message.join(' ')
      end
    end

    def validate_digests
      lookup = @deserialized['files'].inject({}) do |accum, entry|
        accum[entry['filename']] = entry['digest']
        accum
      end

      entries.each do |entry|
        digest    = perform_digest File.join path, entry
        unless lookup[entry] == digest
          errors.add :base, "Differing digest on #{entry}!"
          break
        end
      end
    end

    private
    def still_valid?
      errors.empty?
    end

  end
end
