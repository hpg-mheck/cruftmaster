# cruftmaster/devices/BlockDevice.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Block devices move information in "blocks" of fixed size, and are the norm
# data storage devices such as hard drives, optical disc drives, tape drives,
# and more.  Contrast with character devices.

require "DeviceBase.rb"

class BlockDevice < DeviceBase
    def noun
        "block device"
    end

    def plural
        "block devices"
    end
end
