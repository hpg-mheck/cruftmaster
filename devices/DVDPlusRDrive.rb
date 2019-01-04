# cruftmaster/devices/DVDMinusRDrive.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# DVD+R ("DVD Plus R") was a format created in 2002 by the DVD+RW Alliance,
# outside of the DVD Forum.  As such, the format was not "officially"
# recognized as a DVD variant until 2008.


require "DVDROMDrive.rb"

class DVDPlusRDrive < DVDROMDrive
    def @noun
        "DVD+R drive"
    end
end

