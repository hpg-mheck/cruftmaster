# cruftmaster/Liasons/IsoinfoLiaison.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

require 'singleton'

require_relative 'LiaisonBase.rb'

class IsoinfoLiaison < LiaisonBase
    include Singleton

    def get_command
        return 'iso-info'
    end

    def parse(command_options, output)
    end
end
