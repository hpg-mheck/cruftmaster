# cruftmaster/prerequisites.rb 
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Ensures that required gems and support programs exist on the host.

require './liaisons/GetLiaison.rb'

# NOTE: Do not include 'colorize' in this list.
@required_gems = {
    'inifile'   => 'to parse INI files',
    'json'      => 'to parse and produce JSON data',
    'nokogiri'  => 'to parse and produce XML data'
}


@required_programs = {
    'cdrdao'    => 'to do magical things with optical discs',
    'cdrecord'  => 'to poke at, and be poked at by, CD-ROM/CD-R drives',
    'hwinfo'    => 'to enumerate and inspect hardware devices',
    'iso-info'  => 'to inspect ISO 9660 filesystems and images',
    'lshw'      =>  'to enumerate system hardware',
    'wodim'     => 'to do stuff to the things'
}


begin 
    # SPECIAL CASE: We can't colorize output if colorize isn't available.
    require "colorize"
rescue LoadError
    STDERR.puts "FAULT: cruftmaster requires the 'colorize' gem to provide colorized terminal output."
    STDERR.puts "Try: 'gem install colorize'."
    STDERR.puts "Thank you for failing with cruftmaster."
    exit -1
end


def all_required_gems_available?
    failed = false
    failed_gems_str=""
    @required_gems.each do |name,reason|
        begin
            eval("require '#{name}'")
        rescue LoadError
            STDERR.puts "FAULT: cruftmaster requires the '#{name}' gem #{reason}.".red
            failed_gems_str += " " + name
            failed = true
        end
    end
    if failed
        STDERR.puts "       Try: '".red+"gem install#{failed_gems_str}".cyan+"'.".red
        STDERR.puts "       If you use (or usually use) rvm, make sure you're in a properly configured login shell.".red
        return false
    end
    return true
end


def all_required_programs_available?
    failed = false        
    @required_programs.each do |name,reason|
        begin
            liaison = get_liaison(name)
        rescue
            STDERR.puts "FAULT: cruftmaster requires, but cannot find, a Liaison class for the external program #{name}.".red
            failed = true
        end
    end
    if failed
        STDERR.puts "       If you are building/running from revision control, you may want to check for updates.".red
        STDERR.puts "       If you installed this program using a package manager, please notify your distro maintainer.".red
        return false
    end
    failed = false        
    @required_programs.each do |name,reason|
        liaison = get_liaison(name)
        if !liaison.program_exists?
            STDERR.puts "FAULT: cruftmaster requires the '#{name}' program #{reason}, ".red
            STDERR.puts "       and has a Liaison for it, but can't find the actual program on your system.".red
            failed = true
        end
    end
    if failed
        STDERR.puts "       Try using your package manager to find and install missing programs.".red
        return false
    end
    return true
end
