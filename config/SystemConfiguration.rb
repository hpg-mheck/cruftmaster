# cruftmaster/devices/SystemConfiguration.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Systemwide configuration.  These are the defaults, unless overridden by the
# user configuration or project configuration.
#
# The configuration file normally resides at the following places:
#
# OS/Distro             | Version       | Location
# ----------------------+---------------+------------------------------------
# Fedora Linux          | 29            | /etc/cruftmaster/conf.d/fedora.json
#

class SystemConfiguration
    @config_file_path="~/.cruftmaster/cruftmaster_system_config.json"
    @archive_path="~/disc-archive"
    @default_device="/dev/sr0"

    def LoadConfig
        if !File.exists?(@config_file_path)
            throw NoConfigFile
        end
    end
end

