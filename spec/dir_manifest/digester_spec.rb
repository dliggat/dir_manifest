require 'spec_helper'
require 'tempfile'

describe DirManifest::Digester do
  describe 'initialization' do
    it 'should raise with a non-existent path' do
      expect {
        described_class.new '/not/a/path'
      }.to raise_error DirManifest::NoSuchDirectory
    end

    it 'should raise if a provided file is not a directory' do
      tempfile = Tempfile.new described_class.name
      expect {
        described_class.new tempfile.path
      }.to raise_error DirManifest::NotADirectory
      tempfile.unlink  # Delete tempfile.
    end

    it 'should set the path attribute' do
      obj = described_class.new '/tmp'
      expect(obj.path).to eq '/tmp'
    end
  end
end
