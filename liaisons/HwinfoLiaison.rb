# cruftmaster/Liasons/HwinfoLiaison.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

require 'singleton'

require_relative 'LiaisonBase.rb'

class HwinfoLiaison < LiaisonBase
    include Singleton

    def get_command
        return 'hwinfo'
    end

    def parse(command_options, output)
    end
end
