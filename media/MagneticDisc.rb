# media/MagneticDisc.rb
# Initial author: Matt Heck
# Creation Date:  02JAN2019
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# MagneticDisc
# ------------
# This is a base class for any storage media consisting of magnetic media
# backed for a rigid or flexible substrate in the form of a disc, usually
# with a hole in the middle for the attachment (either temporary or
# permanent) of a spindle motor.

require 'MagneticMedia.rb'
require 'RotaryMedia.rb'

class MagneticDisc < RotaryMedia
    include MagneticMedia
end

