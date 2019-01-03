# standards/hard_drives/RLL_HardDrive.rb
# Initial author: Matt Heck
# Creation Date:  02JAN2019
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# RLL_HardDrive
# -------------
# Run-Length Limited encoded hard disk drives.  In terms of chronology with
# Modified Frequency Modulation (MFM) drives, the name is misleading; while
# MFM drives implement an RLL scheme, "RLL controller cards" implement a
# higher-density one.  So, "MFM controllers" pre-date "RLL controllers".
#
# While it is possible to use an RLL controller card with an MFM drive, doing
# so requires reformatting the drive, and generally results in a much higher
# number of bad sectors-- both during the format, and during operation-- due
# to the higher media standards required.  Nevertheless, the technique was
# popular for bulletin board systems (BBSes), which typically ran on a
# shoestring, needed as much storage as they could get, and expected to blow
# their drives in fairly short order anyway, so there is the possibility of
# encountering this in the wild.
#
# Using an MFM controller on an RLL drive in theory would result in higher
# reliability due to the lower encoding density, but this was rarely, if ever,
# done in practice, due to the significant storage capacity loss.
#
# An RLL controller card CANNOT be used to read an MFM-formatted hard drive.
# An MFM controller card CANNOT be used to read an RLL-formatted hard drive.
# Note that the encoding type should NOT be presumed from the manufacturer's
# specifications; if the drive fails to read with the "appropriate"
# controller, try the other kind.

require 'devices/HardDiskDrive.rb'
require 'standards/encoding/RLL_Encoding.rb'

class RLL_HardDrive < devices < HardDiskDrive
    include RLL_Encoding
end

