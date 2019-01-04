# theories/MSIInstallerTheory.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Theory: MSI Installer
# ---------------------
# This theory proposes that the disc is intended to distribute a software
# program or data set for an end user to install, and provides an "MSI"--
# Microsoft Installer-- image to do so.
#
# If correct, a "setup.msi" or other "*.msi" file should exist; if it does,
# its internal tables should provide the program name and publisher.
#
# Supporting Information
# ----------------------
# - The presence of a single MSI installer and few other files is EXTREMELY
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

class MSIInstallerTheory < Theory
    def Evaluate(context, device, summary)
    end
end

