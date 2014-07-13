require 'digest'
require 'time'
require 'yaml'

class NoSuchDirectory < StandardError; end
class NotADirectory < StandardError; end
class NoSuchAlgorithm < StandardError; end

module DirManifest
  class Digester
    attr_reader :path

    def initialize(path)
      path = File.expand_path path
      raise NoSuchDirectory.new "could not find #{path}" unless File.exists?(path)
      raise NotADirectory.new "#{path} is not a directory" unless File.directory?(path)
      @path = path
    end

    def write_digest
      File.open(digest_file_name, 'w') do |f|
        f.write digest.to_yaml
      end
    end

    def digest
      result = { 'generated' => Time.now.utc.xmlschema,
                 'algorithm' => DirManifest::Config.algorithm,
                 'files'     => [ ] }
      entries.each do |entry|
        file_to_digest   = File.join path, entry
        result['files'] << { 'filename' => entry,
                             'digest'   => perform_digest(file_to_digest) }
      end
      result
    end

    protected
    def digest_file_name
      File.join path, DirManifest::Config.digest_file
    end

    def entries
      @entries ||= begin
        Dir.entries(path)
           .reject { |file| file.start_with? '.' }
           .reject { |file| File.directory? File.join(path, file) }
      end
    end

    def perform_digest(file_name)
      bytes = File.read file_name
      case DirManifest::Config.algorithm
      when 'sha1'
        Digest::SHA1.hexdigest bytes
      else
        raise NoSuchAlgorithm.new 'unsupported algorithm'
      end
    end


  end
end

