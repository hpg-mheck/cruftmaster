# Theory.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Disc evaluators are known as "Theories".  Theories are used to try and
# come up with both a meaningful name for the disc, in case the label is
# missing or worthless, and also to help organize the archive, by figuring
# out some meaningful details about the disc.
#
# Theories are deep inspectors, going well beyond basic data such as blkid,
# iso-info, and so forth.  They require the ability to mount the device or
# image, because they look at both directory information, and file contents.
#
# All theories return a TheoryResults object, which scores the theory from
# 

require 'garnets/virtual.rb'

class Theory
    # Evaluate(CruftMaster context, String device, DeviceSummary summary)
    virtual :Evaluate
end

