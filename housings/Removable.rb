# housings/Removable.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Removable
# ---------
# Removable housings are used to allow drives to accept media changes.  Such
# housings can expose the drive and the media to environmental contamination.
#
# This mixin should be used to indicate that the media for a storage device
# is removable.
require 'housings/fixed'
require 'mechanical/rotary'
require 'physics/magnetic'

class Fixed
    def removable?
        return false
    end
end

