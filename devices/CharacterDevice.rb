# cruftmaster/devices/CharacterDevice.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

require "DeviceBase.rb"

class CharacterDevice < DeviceBase
    def noun
        "character device"
    end

    def plural
        "character devices"
    end
end
