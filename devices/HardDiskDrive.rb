# devices/HardDiskDrive.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# HardDiskDrive
# -------------
# This is a base class for any storage media consisting of one or more rigid,
# rotating platters with a magnetic coating, permanently mounted inside of a
# housing that also contains an armature that moves read/write heads over the
# surface of the media.
#
# Hard disk drives are high-precision, high-performance mechanical devices,
# and have a low tolerance for mechanical shock while operating.

require 'housings/Fixed.rb'
require 'mechanical/NonContact.rb'
require 'mechanical/Rotary.rb'
require 'physics/Magnetic.rb'

class HardDiskDrive < BlockDevice
    include Fixed
    include Magnetic
    include NonContact
    include Rotary
end
