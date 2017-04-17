class Checksum < Struct.new(:inode, :mtime, :size, :md5, :scrubtime, :path)
  def key
    [inode, mtime, size]
  end

  def modified_at
    @modified_at ||= Time.at(mtime)
  end

  def scrubbed_at
    @scrubbed_at ||= Time.at(scrubtime)
  end

  def report
    "* scrubbed_at=#{scrubbed_at.to_s} inode=#{inode} mtime=#{modified_at.to_s} md5=#{md5} path=#{path}"
    "* #{path}\n" +
    "  scrubbed_at=#{scrubbed_at.to_s} inode=#{inode} mtime=#{modified_at.to_s} size=#{size} md5=#{md5}"
  end

  def serialize_v2
    "#{inode},#{mtime},#{size},#{md5},#{scrubtime},#{path}"
  end
end

class ScrubDB
  def initialize
    @scrubs = []
    @by_key = {}
  end

  def add(scrubs)
    @scrubs.concat(Array(scrubs))
    Array(scrubs).each do |scrub|
      @by_key[scrub.key] ||= {}
      @by_key[scrub.key][scrub.md5] ||= []
      @by_key[scrub.key][scrub.md5] << scrub
    end
  end

  def find_errors
    @by_key.select{ |key, by_md5| by_md5.length > 1 }
  end
end

def read_scrubfile(name)
  File.open(name).each_line.map do |line|
    read_line(line)
  end
end

def read_line(line)
  array = line.split(",", 6)
  inode = array[0].to_i
  mtime = array[1].to_i
  size = array[2].to_i
  md5 = array[3]
  scrubtime = array[4].to_i
  path = array[5].rstrip
  Checksum.new(inode, mtime, size, md5, scrubtime, path)
end

def recent_scrubfile_names(dir, newer_than_in_days = 7)
  Dir.glob(dir + "/*.scrubfile").select do |name|
    File.ctime(name) > Time.now - 60*60*24*newer_than_in_days
  end
end
