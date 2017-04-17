#!/usr/bin/env ruby

require "openssl"
require "digest"

files = []
ARGV.each do |name|
  begin
    files << File.open(name)
  rescue StandardError => e
    $stderr.puts e.message
  end
end

$stdout.sync = true

files.each do |file|
  begin
    stat = file.stat
    inode = stat.ino
    mtime = stat.mtime.to_i
    size = file.size
    now = Time.now.to_i
    md5 = OpenSSL::Digest::MD5.file(file).hexdigest
    path = file.path

    $stdout.puts [inode, mtime, size, md5, now, path].join(",")
    $stdout.flush
  rescue StandardError => e
    $stderr.puts e.message
  end
end
