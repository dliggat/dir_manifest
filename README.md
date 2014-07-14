dir_manifest
============

dir_manifest is a Ruby gem with two modes of operation:

* `create`: Create a YAML file specifying a list of all files in a directory, a cryptographic digest of their contents (currently SHA1), and a timestamp when the digest was created.
* `verify`: Given a directory with a digest YAML file, verify that each file is present, no additional files exist, and each expected file's cryptographic digest matches what was recorded at the time of manifest creation.
