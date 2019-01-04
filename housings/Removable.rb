# housings/Removable.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Removable
# ---------
# Removable housings are used to allow drives to accept media changes.  Such
# housings can expose the drive and the media to environmental contamination.
#
# This mixin should be used to indicate that the media for a storage device
# is removable.

require "garnets/virtual.rb"
require 'housings/fixed.rb'
require 'mechanical/rotary.rb'
require 'physics/magnetic.rb'

class Removable
    def removable?
        return true
    end

    virtual close_tray
    virtual eject
    virtual open_tray

    virtual media_blank?
    virtual media_present?
    virtual tray_closed?
    virtual tray_open?

end

