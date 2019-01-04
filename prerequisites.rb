# cruftmaster/theories/prerequisites.rb 
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Ensures that required gems and support programs exist on the host.

begin 
    require "colorize"
rescue LoadError
    STDERR.puts "FAULT: cruftmaster requires the 'colorize' gem to provide colorized terminal output."
    STDERR.puts "Try: 'gem install colorize'."
    STDERR.puts "Thank you for failing with cruftmaster."
    exit -1
end

begin 
    require "json"
rescue LoadError
    STDERR.puts "FAULT: cruftmaster requires the 'json' gem to parse and produce JSON data.".red
    STDERR.puts "Try: '".red+"gem install json".cyan+"'.".red
    STDERR.puts "Thank you for failing with cruftmaster.".red
    exit -1
end

begin 
    require "nokogiri"
rescue LoadError
    STDERR.puts "FAULT: cruftmaster requires the 'nokogiri' gem to parse and produce HTML data.".red
    STDERR.puts "Try: '".red+"gem install nokogiri".cyan+"'.".red
    STDERR.puts "Thank you for failing with cruftmaster.".red
    exit -1
end

begin 
    require "inifile"
rescue LoadError
    STDERR.puts "FAULT: cruftmaster requires the 'inifile' gem to parse INI file data.".red
    STDERR.puts "Try: '".red+"gem install inifile".cyan+"'.".red
    STDERR.puts "Thank you for failing with cruftmaster.".red
    exit -1
end

