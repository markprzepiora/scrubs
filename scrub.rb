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

files.each do |file|
  begin
    stat = file.stat
    inode = stat.ino
    mtime = stat.mtime.to_i
    now = Time.now.to_i
    md5 = OpenSSL::Digest::MD5.file(file).hexdigest
    path = file.path

    puts [inode, mtime, md5, now, path].join(",")
  rescue StandardError => e
    $stderr.puts e.message
  end
end
