# theories/INFDriverDiskTheory.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Theory: Windows device driver disk with an .INF file
# ----------------------------------------------------
# This theory proposes that the disc or diskette is intended to distribute
# the device driver for a hardware device (or, less frequently, some other
# non-application code or data, such as a compression codec), and contains
# an .INF file that describes the device or subsystem supported.
#
# If correct, some "*.INF" file should exist; if it does, it should provide
# further details, such as the device and manufacturer names.
#
# Supporting Information
# ----------------------
# - The presence of a "*.INF" file in the root directory is EXTREMELY
#   CONVINCING.
#
# - The presence of an AUTORUN.INI file is consistent with the theory, as
#   driver disks also contained installers for speciality programs, and is
#   VERY CONVINCING if and only if the *.INF file exists.
#
# Mitigating Information
# ----------------------
# - The absence of any filename of the form *.INF directly conflicts with the
#   theory, and is EXTREMELY UNCONVINCING.  (However, some *.INF files were
#   supplied as part of compressed archives.)
#
# - The presence of UNIX filetypes or names (e.g., *.tar.gz, *.tgz, ISOLINUX)
#   conflicts with the theory of an installation CD for a Windows program,
#   and is VERY UNCONVINCING.
#
# - The presence of multiple INF files from different authors/publishers may
#   indicate a manually-compiled multi-device driver disk, perhaps composed
#   of all drivers needed for a particular computer, and is therefore
#   UNCONVINCING.
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
# - Device driver disks which included a full *.EXE or *.MSI program that 
#   unpakced the driver from a .CAB file.
#   TODO: Check CAB files.
#
# - Device driver disks supplied as compressed archives, such as ZIP files.

class INFDriverDiskTheory < Theory
end
