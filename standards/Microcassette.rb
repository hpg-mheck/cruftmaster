# Microcassette.rb
# Initial author: Matt Heck
# Creation Date:  02JAN2019
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Microcassette
# -------------
# A very small audio cassette format introduced by Olympus in 1969.

require 'media/AnalogMagneticTape.rb'
require 'housings/Cassette.rb'

class CompactCassette < AnalogMagneticTape
    include Cassette
end

