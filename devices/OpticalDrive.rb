# cruftmaster/devices/OpticalDrive.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

require './garnets/virtual.rb'

require_relative './DeviceBase.rb'

class OpticalDrive < DeviceBase
    def noun
        "optical drive"
    end
    
end
