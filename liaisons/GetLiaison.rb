# cruftmaster/Liasons/GetLiaison.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com


# FIXME - clean up excepion hierarchy
class NoSuchProgramError < StandardError
    def initialize(msg)
        super(msg)
    end
end


# FIXME - clean up excepion hierarchy
class NoSuchLiaisonError < StandardError
    def initialize(msg)
        super(msg)
    end
end


# Returns the Liaison name for a given command.  This is useful for finding both
# the Liaison class name, and the filename.  Note that this command DOES NOT
# ensure the class or file exists, it's just a string-mangler!
def get_liaison_name(command_name)
    return command_name.capitalize.tr('_','').tr('-','') + "Liaison"   
end


# Returns the liaison singleton for a given command.  Does NOT immediately check
# whether or not the program exists; use the returned class's "program_exists?"
# method to check that.
def get_liaison(command_name)
    classname = get_liaison_name(command_name)
    filename = classname+".rb"
    program_exists = false

    begin
        require "./liaisons/#{filename}"
    rescue LoadError # FIXME-- I think this has to be a particular error for this case to work
        raise NoSuchLiaisonError.new(filename)
    end

    begin
        liaison = eval("#{classname}.instance")
    rescue
        raise ClassIsNotASingletonError.new(classname)
    end

    return liaison
end

