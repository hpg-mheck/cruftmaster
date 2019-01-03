# housings/Cassette.rb
# Initial author: Matt Heck
# Creation Date:  02JAN2019
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Cassette
# --------
# This is a base class for any storage media consisting of magnetic,
# optical, or punched tape wound onto one (e.g., 8-Track) or two
# (e.g., Compact Cassette) reels, enclosed in a shell (typically plastic).
#
# Cassettes provide simplified handling and improved environmental protection
# for magnetic tapes compared to bare tape reels.  Their main commercial
# advantage is greatly reduced loading and unloading time.  The main new
# feature introduced, relative to reel-to-reel tapes, is the ability to be
# loaded and unloaded while maintaining a cue point; this cannot be safely
# done with open-reel tapes (certainly not for transport).
#
# Some cassette formats include a tension backing plate which provides
# forward pressure to hold the tape in contact with the deck/drive head(s).
# This plate is typically faced with either a roller or a soft pad.  Pads,
# when used, are attached with an adhesive which can fail over time, leading
# to inadequate head contact during operation.
#
# Cassette shells exposed to excess temperature, and in particular direct
# sunlight, can warp.  A warped cassette shell can cause poor media
# performance, and, in extreme cases, can damage the media.  In many cases,
# the media reel(s) can be transferred to a surrogate shell in good condition
# for recovery purposes.

class Cassette < Reel

end

