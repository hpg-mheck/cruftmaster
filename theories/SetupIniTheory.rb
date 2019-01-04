# theories/SetupIniTheory.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Theory: Windows Installer with Setup.ini
# ----------------------------------------
# This theory proposes that the disc is intended to distribute a software
# program or data set for an end user to install, and contains a SETUP.INI
# file that describes what is provided.
#
# If correct, a "Setup.ini" file should exist; if it does, it should provide
# the program name and publisher.
#
# Supporting Information
# ----------------------
# - The presence of a Setup.ini file in the root directory is EXTREMELY
#   CONVINCING.
#
# - The presence of an AUTORUN.INI file is consistent with the theory of a
#   Windows installation CD, and is VERY CONVINCING.
#
# - The presence of a small number of MSI installers, whose ProductName
#   fields have common root names, is VERY CONVINCING.
#
# - The presence of a small number of MSI installers, whose ProductNames are
#   different, but where one MSI installer is much larger than the others--
#   perhaps indicating a major program and some supplemental utilities-- is
#   CONVINCING.
#
# - The presence of one or more MSI installers, and a number of other
#   unrelated files is SOMEWHAT CONVINCING.
#
# Mitigating Information
# ----------------------
# - The absence of any filename of the form *.MSI (or *.msi) directly
#   conflicts with the theory, and is EXTREMELY UNCONVINCING.
#
# - The presence of UNIX filetypes or names (e.g., *.tar.gz, *.tgz, ISOLINUX)
#   conflicts with the theory of an installation CD for a Windows program,
#   and is VERY UNCONVINCING.
#
# - The presence of multiple MSI installers from different authors/publishers
#   may indicate a manually-compiled offload of a download directory, etc.,
#   and is therefore UNCONVINCING.
#
# - The presence of a large number of files of different naming formats and
#   types may indicate a CD used to clear space out of a download directory,
#   desktop, or other area, and is SOMEWHAT UNCONVINCING.
#
# False Positives
# ---------------
# None known.
#
# False Negatives
# ---------------
# None known.

class SetupIniTheory < Theory

    def consider_windows_setup(drive, summary)
        summary['theories']['windows_setup']={}
        summary['theories']['windows_setup']['score']=0.0
        summary['theories']['windows_setup']['best_name']="BAD_THEORY"

        # See if a setup.ini file exists.  These have to be case-insensitive.
        # At the moment, only the root is checked.
        matches=`find /run/media/mheck/DVD1 -maxdepth 1 -iname setup.ini`.split("\n")

        # FIXME - consider multiple matches?
        if matches.count<1
            if #extraverbose
                log "Windows Setup theory is unlikely."
            end
            return summary
        end

        begin
            setup_ini = IniFile.load(matches[0])
        rescue ArgumentError
            # This can be generated for older UTF-16 files
            setup_ini_file = File.open(matches[0], "rb:UTF-16LE")
            setup_ini_xlat = ""
            setup_ini_file.each do |line|
                # FIXME-- use Iconv
                setup_ini_xlat += line
            end
            setup_ini_file.close
            setup_ini = IniFile.new( :content => setup_ini_xlat )
        end

        begin
            warn setup_init['Setup']['Name']
            summary['theories']['windows_setup']['score']=1.0
            summary['theories']['windows_setup']['best_name']=setup_init['Setup']['Name']
        rescue
        end

        begin
            warn setup_init['Setup']['ProdName']
            summary['theories']['windows_setup']['score']=1.0
            summary['theories']['windows_setup']['best_name']=setup_init['Setup']['ProdName']
        rescue
        end
        

        return summary
    end

end