# CompactCassette.rb
# Initial author: Matt Heck
# Creation Date:  02JAN2019
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# CompactCassette
# ---------------
# The Compact Cassette or "audiocassette" is known to most users simply as
# a "cassette tape".  It is similar to the much larger, and much rarer,
# Elcaset, and consits of two reels and a magnetic tape of various lengths.
#
# FIXME

require 'media/AnalogMagneticTape.rb'
require 'housings/Cassette.rb'

class CompactCassette < AnalogMagneticTape
    include Cassette
end

