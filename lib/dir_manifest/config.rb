require 'dir_manifest/config/options'

module DirManifest

  module Config
    extend self
    extend Options

    option :algorithm,   default: 'sha1'
    option :digest_file, default: '.digest.yml'
  end
end
