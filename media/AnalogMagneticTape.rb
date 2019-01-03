# AnalogMagneticTape.rb
# Initial author: Matt Heck
# Creation Date:  02JAN2019
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# AnalogMagneticTape.rb
# ---------------------
# A magnetic recording tape using analog modulation.

require 'Tape.rb'
require 'physics/Magnetic.rb'

class AnalogMagneticTape < Tape
    include Magnetic
end

