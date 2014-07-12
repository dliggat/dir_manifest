#!/usr/bin/env ruby

require 'digest'
require 'time'
require 'yaml'

class NoSuchDirectory < StandardError; end

class Digester
  attr_reader :path

  def initialize(path)
    raise NoSuchDirectory.new "could not find #{path}" unless File.exists?(path)
    @path = path
  end

  def entries
    @entries ||= begin
      Dir.entries(path)
         .reject { |file| file.start_with? '.' }
         .reject { |file| File.directory? File.join(path, file) }
    end
  end

  def digest
    result = { 'generated' => Time.now.utc.xmlschema,
               'algorithm' => 'sha1',
               'files'     => [ ] }
    entries.each do |entry|
      result['files'] << { 'filename' => entry,
                           'digest'   => Digest::SHA1.hexdigest(File.read(File.join(path,entry))) }
    end
    result
  end

end


d = Digester.new(File.expand_path ARGV.first)
puts d.digest.to_yaml
