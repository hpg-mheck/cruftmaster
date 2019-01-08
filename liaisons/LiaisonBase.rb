# cruftmaster/LiaisonBase.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

class BlkidLiaison < LiaisonBase
    # Reasonably safe default.
    @command='echo'

    # This hash maps use case names to option strings.
    @use_cases={}

    def run(use_case)
        if !@use_cases.has_key?(use_case)
            throw NoSuchUseCaseError
        end
    end

    def run_manual(command_options)
    end

    def parse(command_options, output)
        # FIXME
    end

    # PRIVATE METHODS #

    # This function handles pre-parser cleanup that most methods appreciate, such as
    # dropping comments that start with '#'
    def pre_parse(command_options, output)
        # FIXME
    end
end
