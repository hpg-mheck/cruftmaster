#!/usr/bin/ruby

# rip-disc.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

$logfile=nil

# Report a fault when the logfile has failed.
def prelogfault(x)
    STDERR.puts "FAULT: ".red+x
    STDERR.puts "Thank you for failing with cruftmaster.".red
    exit -1
end


# Open the logfile.
def start_logger(filename)
    $logfilename=filename
    begin
        $logfile = File.open($logfilename, "w+");
    rescue 
        prelogfault "cruftmaster couldn't write to "+"#{$logfilename}".colorize("cyan")+", committing seppuku with a spork"
        exit -1
    end
end

# Log a message to stdout, and the logfile.
def log(x)
    begin
        puts (nowstr()+": ").cyan+x
        $logfile.puts (nowstr()+": ").cyan()+x
    rescue 
        STDERR.puts "FAULT: cruftmaster couldn't write to #{$logfilename}; disk full?".red
        exit -1
    end       
end


# Log a message to stdout, and the logfile, using a color only used for prompts.
def prompt(x)
    begin
        puts (nowstr()+": ").cyan+x.magenta
        $logfile.puts (nowstr()+": ").cyan+": "+x.magenta
    rescue 
        STDERR.puts "FAULT: cruftmaster couldn't write to #{$logfilename}; disk full?".red
        exit -1
    end       
end


# Log a message to stdout, and the logfile, using a color only used for warnings.
def warn(x)
    begin
        puts (nowstr()+": ").cyan+("WARNING: ".yellow)+x
        $logfile.puts (nowstr()+": ").cyan+("WARNING: ".yellow)+x
    rescue 
        STDERR.puts "FAULT: cruftmaster couldn't write a warning to #{$logfilename}; disk full?".red
        exit -1
    end       
end


# Log a message to stderr, and the logfile, using a color only used for errors, but proceed.
def warn(x)
    begin
        STDERR.puts (nowstr()+": ").cyan+("ERROR: ".red)+x
        $logfile.puts (nowstr()+": ").cyan+("ERROR: ".red)+x
    rescue 
        STDERR.puts "DOUBLE FAULT: cruftmaster couldn't write an error to #{$logfilename}; disk full?".red
        exit -1
    end       
end


# Log a message to stderr, and the logfile, using a color only used for errors, then abort
# the entire program.
def fault(x)
    begin
        STDERR.puts "FAULT: ".red+x
        STDERR.puts "Thank you for failing with cruftmaster.".red
        $logfile.puts "FAULT: ".red+x
        $logfile.puts "Thank you for failing with cruftmaster.".red
    rescue
        STDERR.puts "DOUBLE FAULT: cruftmaster couldn't write a fault to #{$logfilename}; disk full?".red
    end
    exit -1
end


