# standards/hard_drives/ATA.rb
# Initial author: Matt Heck
# Creation Date:  02JAN2019
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# ATA
# ---
# The Advanced Technology Attachment interface grew out of the earlier
# Integrated Drive Electronics (IDE) standards.  It was developed largely for
# use with the IBM PC/AT ("Advanced Technology"), which as based on the Intel
# 80286, and had additional I/O capabilities.
#
# The ubiquitous IDE/ATA connector was a 40-pin ribbon cable.  ATA has gone
# through many generations of standards, with accelerating speeds and
# improved capabilities.  The most phyiscally obvious of these switched the
# 40-pin cable out for a much more compact high-density edge connector; this
# was possible by replacing the parallel data transmission techniques with a
# very high-speed serial data stream.  As such, these later drives are known
# as Serial ATA, or "SATA", and-- only in retrospect-- the original, 40-pin
# drives have come to be referred to as Parallel ATA, or "PATA", a term which
# was never used prior to the introduction of SATA.
#
# At the time, the major innovation of IDE was to move most of the "how to be
# a hard drive" logic onto the drive itself.  This greatly simplified the bus
# interface cards, known as "IDE controller cards", allowing them to be
# compatible with a wide range of makes and models without having to know
# about their internal quirks.  An IDE controller typically knows only about
# the drive's geometry-- classically, in terms of heads, cylinders, and
# sectors, though modern drives are interfaced with primarily in terms of
# absolute offsets known as logical block addresses (LBA).  Other than this
# geometry conversion, the card's main responsibilities are simply command,
# response, and data buffering.
#
# Note that the various ATA "levels" (ATA-3, ATA-6, etc.) are all handled
# by this class.
#
# The PATA and SATA standards derive from this standard.

require 'IDE'

class ATA < IDE

end

