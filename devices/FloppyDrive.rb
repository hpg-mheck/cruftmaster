# devices/FloppyDrive.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# FloppyDrive
# -----------
# This is a base class for a floppy diskette drive, which takes removable
# media consisting of a single flexible magnetic disc in a flexible or rigid
# protective case.  The media makes physical contact with a linear read head
# in the drive (often one on each side of the diskette; for single-head
# drives, the diskette will need to be flipped).
#
# Floppy disk drives are medium-precision, low-performance mechanical devices,
# which have a moderate tolerance for mechanical shock while operating, and
# require occasional head cleaning.

require "BlockDevice.rb"
require 'housings/Removable.rb'
require 'mechanical/Contact.rb'
require 'mechanical/Rotary.rb'
require 'physics/Magnetic.rb'

class FloppyDrive < BlockDevice
    include Contact
    include Magnetic
    include Removable
    include Rotary
end
