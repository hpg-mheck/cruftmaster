# cruftmaster/Liasons/BlkidLiaison.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

require 'singleton'

require_relative 'LiaisonBase.rb'

class BlkidLiaison < LiaisonBase
    include Singleton

    def get_command
        return 'blkid'
    end

    def parse(command_options, output)
    end
end
