# Scrubs

Do you find yourself using a non-ZFS filesystem and missing `zfs scrub`? This
is a simple solution that gets you most of the way there regardless of your
filesystem.

## Warning

This repository is a work in progress.

Do not use yet!

## Overview

Scrubs is composed of two, simple programs, which will likely be renamed:

1. `scrub.rb` - which is responsible for performing a checksum of a given list
   of files, and outputting lines of plaintext which can be parsed by the
   following program.
2. `find_errors.rb` - which reads one or more scrubfiles generted by the first
   program and finds files which may be corrupted.

## How it works

The first `scrub.rb` program records six pieces of information for each file
scrubbed:

1. The file's inode number.
2. The file's modification time (mtime).
3. The file's size in bytes.
4. The file's MD5 checksum.
5. The timestamp when this file was scrubbed.
6. The file's path and filename.

The heuristic Scrubs uses to detect corruption is that if fields 1, 2, and 3
are the same for any two given scrubs, then field 4 should also be the same.

Field 5 is recorded so that we can figure out when the file was damaged.

Field 6 is recorded just for display purposes, to show the user what was
damaged. It is not used to identify files.

## Caveats

Since Scrubs relies on a file's inode number to identify it, you can only use
Scrubs on local filesystems, and not network shares. Also, filesystems like
FAT32, NTFS (?) which do not have inodes will report made-up inode numbers
which will not persist through reboots, so you shouldn't use Scrubs on these
filesystems.

So basically, you can use this on ext* and HFS+ systems. And I guess btrfs? Who
knows. I use this on my NAS which spots an ext4 system.

You also can't use this across two different filesystems (say comparing a
source drive to a backup target) since the inodes will be different.
