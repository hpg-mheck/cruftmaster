# standards/hard_drives/IDE.rb
# Initial author: Matt Heck
# Creation Date:  02JAN2019
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# IDE
# ---
# Integrated Drive Electronics, the original 40-pin interface standard that
# evolved into the eventual PATA (at the time, simply "ATA") and later SATA
# standards.
#
# At the time, the major innovation of IDE-- Integrated Drive Electronics--
# was to move most of the "how to be a hard drive" logic onto the drive
# itself.  An interface card was still typically required, but was much
# simpler than those required for earlier MFM/RLL drives, typically only
# handling data buffering.
#
# This standard is archaic; the ATA standard, which is based on it, should be
# used for almost all purposes.

require 'devices/HardDiskDrive.rb'

class IDE < HardDiskDrive

end

