#!/usr/bin/env ruby

require_relative 'lib/scrubs'

recently_scanned_db = RecentlyScannedDB.load_files(recent_scrubfile_names(ARGV))

# Unlike String#chomp, this function does NOT chomp a \r before the \n if
# present. Why? Because OSX don't give a shit, and when you set a custom icon
# for a folder in Finder, OSX saves that icon as a file named "Icon\r". Yes,
# really.
def chomp_newline(line)
  if line[-1] == "\n"
    line[0..-2]
  else
    line
  end
end

STDIN.each_line do |name|
  name = chomp_newline(name)

  unless recently_scanned_db.already_scanned?(name)
    puts name
  end
end
