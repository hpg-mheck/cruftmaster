# cruftmaster/standards/DVDDashR.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# DVD-R ("DVD dash R") was the initial recordable format created by the DVD
# Forum.  It competed with DVD+R, with which it is not compatible, though
# some drives implement support for both.
#
# Almost any DVD device should be able to read a DVD-R disc in good
# condition; however, the total reflectivity is lower, so if the laser's
# output has decreased, playback may fail.
#
# Devices capable of writing DVD-R discs should include this mixin.
#
# SAFETY NOTE: DVD-R discs include tellurium in the recording layer.  Dust
# masks should be worn during mechanical destruction, such as shredding.

class DVDDashR < StandardBase

end

