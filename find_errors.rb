#!/usr/bin/env ruby

require_relative 'lib/functions'

scrubs = ARGV.map do |name|
  read_scrubfile(name)
end.flatten

scrub_db = ScrubDB.new
scrub_db.add(scrubs)
scrub_db.find_errors.each do |key, by_md5|
  puts "--"
  by_md5.values.flatten.sort_by(&:modified_at).each do |checksum|
    puts checksum.report
  end
end
