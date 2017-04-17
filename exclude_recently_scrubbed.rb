#!/usr/bin/env ruby

require_relative 'lib/scrubs'

recently_scanned_db = RecentlyScannedDB.load_files(recent_scrubfile_names(ARGV))

STDIN.each_line do |name|
  name.strip!

  unless recently_scanned_db.already_scanned?(name)
    puts name
  end
end
