#!/usr/bin/ruby

# rip-disc.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

require './prerequisites.rb'
require './Logging.rb'

# You're ripping a giant pile of scratched discs.
# A sense of humor is not optional.
require './humor.rb'
require './devices/CDROMDrive.rb'

$exit_requested=false
$verbose=false
$extraverbose=true

def nowstr
    `date +%Y%m%d%Z%H%M%S`.strip
end

$ripdev="/dev/sr0"
$staging="/home/mheck/mnt/DISASTER AREA/disc-archiving"
$startedat=nowstr()
$safetyfilename="#{$staging}/cruftmaster.safety"


# See if the safety file exists.
if !File.exists?("#{$staging}/cruftmaster.safety")
    prelogfault( "cruftmaster couldn't find the safety file.  This file is used to ensure an unmounted " +
           "mountpoint is not accidentally written to.  Check that the target directory, " +
           $staging.cyan+", looks correct, and that any filesystem that should be " +
           "mounted there indeed is, then run '" + "touch #{$safetyfilename}".yellow + "'.")
end




# ################### MAIN LOOP #################### #
$ripdev = detect_drive("/dev/sr0")

def main_loop
    # Install CTRL-C handler
    Kernel.trap("INT") {
        warn "Caught CTRL-C, requesting exit..."
        $exit_requested=true; 
    }

    while (!$exit_requested)
        
        prompt "Please place the next disc in the drive within sixty seconds."
        
        if !wait_for_disc($ripdev, 60)
            log "No disc inserted after sixty seconds; closing drives and shutting down."
            close_tray($ripdev)
            return
        end
        
        if disc_blank?($ripdev)
            warn "This disc appears to be blank-- but cruftmaster isn't good at distinguishing blank media " +
                 "from \"weird\" discs yet.  Try with other tools.  Meanwhile, insert the next disc, or " +
                 "press CTRL-C..."
            eject($ripdev)
            next
        end

        log "This " + get_trite_disc_nickname() + " looks like a " + get_verbose_disc_type($ripdev) + " disc."
      
        summary=glance($ripdev)

        if (summary['content_type']=='MIXED')
            log "As such, it contains both audio and data sections, and must be handled accordingly for"
            log "reliable archiving, if the disc is to be reconstructable."
        end

        if (summary['has_data'])
            case summary['filesystem_type']
            when "UNKNOWN"
                warn "FILESYSTEM UNKNOWN"
                warn "While the encoding indicates a data disc, the filesystem type is not immediately apparent."
                warn "If a filesystem is known to be present, it may be encrypted.  However, it is possible this"
                warn "is a multi-session disc that was not properly closed.  It is also possible that the disc"
                warn "contains a data stream that was directly encoded, without a filesystem.  The disc could"
                warn "contain a hard-disk style partition table at the beginning.  Finally, the disc may simply"
                warn "be damaged, or have failed to properly record.  The disc will still be imaged."
            when "iso9660"
                if (summary.has_key?("megabytes_stored"))
                    log "The disc appears to contain #{summary['megabytes_stored']}MB of data in an ISO-9660 filesystem."
                else
                    log "The disc appears to contain an ISO-9660 filesystem."
                end
            when "udf"
                if (summary.has_key?("megabytes_stored"))
                    log "The disc appears to contain #{summary['megabytes_stored']}MB of data in a UDF filesystem."
                else
                    log "The disc appears to contain a UDF filesystem."
                end
            else
                warn "UNCOMMON FILESYSTEM"
                if (summary.has_key?("megabytes_stored"))
                    log "The disc appears to contain #{summary['megabytes_stored']}MB of data in a #{summary.filesystem_type} filesystem."
                else
                    log "The disc appears to contain a #{summary.filesystem_type} filesystem."
                end
            end
        end

        if (summary.has_key?("volume_label"))
            log "Volume label:     #{summary['volume_label']}"
        end
        if (summary.has_key?("uuid"))
            log "UUID:             #{summary['uuid']}"
        end
        if (summary.has_key?("filesystem_label"))
            log "Filesystem label: #{summary['filesystem_label']}"
        end
        if (summary.has_key?("disc_preparer"))
            log "Disc preparer: #{summary['disc_preparer']}"
        end
        if (summary.has_key?("disc_publisher"))
            log "Disc publisher: #{summary['disc_publisher']}"
        end
        if (summary.has_key?("best_date"))
            log "Possible date:    #{summary['best_date']}"
        end

        # Get some more information.
        summary = stare($ripdev, summary)


        # DEVHACK
        $exit_requested=true
    end
end


# ################### START #################### #

start_logger("#{$staging}/logs/cruftmaster-#{$startedat}.log")

log "Reluctantly beginning operations.  Oh no, not again.".green

#eject($ripdev)
main_loop()

ENDEDAT=nowstr()
log "Ending operations.  Have a nice daycycle."
$logfile.close
