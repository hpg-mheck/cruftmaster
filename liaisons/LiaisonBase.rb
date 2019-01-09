# cruftmaster/Liasons/LiaisonBase.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

require './DebugBase.rb'

class LiaisonBase < DebugBase
    # Reasonably safe default.
    def get_command
        return 'echo'
    end

    # This hash maps use case names to hashes of version numbers and option strings.
    # By doing this, the program can work across a wide range of utility versions and
    # environments.
    #
    # use_cases = { 'some use case' : { 'platform or generic' : { 'minimum_version' : 'command options' } } }
    def get_use_cases
        return { 'selftest' => { 'generic' => { '0.0.0' => ''} } }
    end

    # Checks to make sure the program is available.
    def program_exists?
        command = get_command()
        # puts "checking for #{command}"
        check_output=`which #{command} 2>&1`
        if check_output.include?("which: no #{command} in (")
            warn "Requested program #{command} was not found."
            return false
        end
        return true
    end

    def run(use_case)
        if !get_use_cases.has_key?(use_case)
            raise UnsupportedUtilityUseCaseError.new(use_case)
        end

        # FIXME
        platform = 'generic'
        if !get_use_cases[use_case].has_key?(platform)
            raise UnsupportedUtilityPlatformError.new(platform)
        end

        # FIXME, this one in particular is way wrong, needs to fail back
        version='0.0.0'
        if !get_use_cases[use_case][platform].has_key?(version)
            raise UnsupportedUtilityVersionError.new(version)
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


