# cruftmaster/theories/Investigate.rb 
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

def consider_theories(drive, summary)
    # Make a scoring hash.
    # These each have the following members:
    # 'score' : A floating-point number from 0.0 (no chance) to 1.0 (definitely) where 0.5 is "no opinion".
    # 'proposed_name' : The best name the theory can come up with.
    summary['theories']={}

    #summary=consider_windows_setup(drive, summary)

    #if 0
    #summary=consider_digital_audio          (drive, summary)
    #summary=consider_digital_documents      (drive, summary)
    #summary=consider_digital_photos         (drive, summary)
    #summary=consider_dos_bootable           (drive, summary)
    #summary=consider_linux_bootable         (drive, summary)
    #summary=consider_presentations          (drive, summary)
    #summary=consider_unix_home_backup       (drive, summary)
    #summary=consider_windows_home_backup    (drive, summary)
    #summary=consider_windows_driver         (drive, summary)
    #end

end


def stare(drive, summary)
    # Mount and inspect the filesystem.

    # See if the drive is already mounted.
    findmnt_out = `findmnt --json -n -l -U /dev/sr0`
    findmnt_hash = JSON.parse(findmnt_out)

    if $extraverbose
        log "Dumping findmnt results..."
        log findmnt_hash.to_s
    end

    findmnt_hash['filesystems'].each do |filesystem|
        if filesystem['source']==drive
            mountpoint = filesystem['target']
            log "Drive #{drive} appears to have been automatically mounted at #{mountpoint}"
            summary['mountpoint']=mountpoint
        end
    end

    # Try and figure out what kind of material this is.
    summary=consider_theories(drive, summary)
    
    return summary
end


