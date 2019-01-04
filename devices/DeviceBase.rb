# cruftmaster/devices/CharacterDevice.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

require './DebugBase.rb'
require "./garnets/virtual.rb"

class DeviceBase < DebugBase
    # The class must define a static method to return the appropriate
    # generic noun for the device type.
#   virtual @noun

    # The device should return true if and only if it is ready to read data
    # from the media.  If it is not, or if no media is present, it should
    # return false.
    virtual :ready?

    # This is the operating system's name for the device, such as "/dev/sdf"
    # on Linux.
    attr_accessor :actual_device
end
