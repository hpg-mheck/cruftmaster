# cruftmaster/Liasons/LshwLiaison.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

require 'singleton'

require_relative 'LiaisonBase.rb'

class LshwLiaison < LiaisonBase
    include Singleton

    def get_command
        return 'lshw'
    end

    def get_use_cases
        return {
            'selftest' => {
                'generic' => {
                    '0.0.0' => ''
                }
            },
            'identify device' => {
                'generic' => {
                    '0.0.0' => '-json'
                }
            }
        }
    end

    def parse(command_options, output)
    end
end
