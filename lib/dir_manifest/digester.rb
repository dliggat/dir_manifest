require 'digest'
require 'time'
require 'yaml'

class NoSuchDirectory < StandardError; end
class NotADirectory < StandardError; end

module DirManifest
  class Digester
    FILENAME = 'digest.yml'
    attr_reader :path

    def initialize(path)
      raise NoSuchDirectory.new "could not find #{path}" unless File.exists?(path)
      raise NotADirectory.new "#{path} is not a directory" unless File.directory?(path)
      @path = path
    end

    def digest
      result = { 'generated' => Time.now.utc.xmlschema,
                 'algorithm' => 'sha1',
                 'count'     => entries.count,
                 'files'     => [ ] }
      entries.each do |entry|
        result['files'] << { 'filename' => entry,
                             'digest'   => Digest::SHA1.hexdigest(File.read(File.join(path,entry))) }
      end
      result
    end

    def verify
    end

    def write
      File.open(digest_file_name, 'w') do |f|
        f.write digest.to_yaml
      end
    end

    private
    def digest_file_name
      File.join path, FILENAME
    end

    def entries
      @entries ||= begin
        Dir.entries(path)
           .reject { |file| file.start_with? '.' }
           .reject { |file| File.directory? File.join(path, file) }
      end
    end


  end
end

  # d = Digester.new(File.expand_path ARGV.first)
  # puts d.digest.to_yaml

