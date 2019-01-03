# housings/Fixed.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Fixed
# -------------
# Fixed housings are used to permanently seal the recording media into the
# read/write equipment, away from environmental contamination.
#
# This mixin should be used to indicate that the recording media in a storage
# device cannot be removed.

require 'housings/fixed'
require 'mechanical/rotary'
require 'physics/magnetic'

class Fixed
    def removable?
        return false
    end
end

