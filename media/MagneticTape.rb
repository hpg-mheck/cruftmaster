# media/MagneticTape.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# MagneticTape
# ------------
# This is a base class for any storage media consisting of a magnetic data
# storage layer on top of, or integrated with, a flexible substrate.
#
# In addition to the characteristics of Tape media in general, magnetic tapes
# suffer from some unique artifacts, such as print-through, where the signal
# from one wrap around the reel is partially imparted to the wrap above or
# below, though at a low level.

require 'MagneticMedia.rb'
require 'Tape.rb'

class MagneticTape < Tape
    include MagneticMedia
end

