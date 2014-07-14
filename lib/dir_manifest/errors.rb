module DirManifest
  class NoSuchDirectory < ArgumentError; end
  class NotADirectory < ArgumentError; end
  class UnsupportedAlgorithm < ArgumentError; end
end
