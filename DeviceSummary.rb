# DeviceSummary.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# This class contains information thus far discovered about the image or
# block device being inspected.  The cutoff line is that this object does
# not contain any information would require inspecting the contents of
# particular files or directories (including the root directory).  However,
# filesystem metadata for the filesystem itself (such as a label) is
# acceptable; metadata for individual enumerated files or directories is not.

class DeviceSummary
    attr_accessor :block_device_info
    attr_accessor :filesystem_info
end
