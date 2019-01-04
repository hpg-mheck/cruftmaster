# cruftmaster/devices/CDROMDrive.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

require_relative "OpticalDrive.rb"

class CDROMDrive < OpticalDrive
    # IOCTLs for CD-ROM drives under Linux.
    CDROM_DRIVE_STATUS = 0x5326
    CDROM_DISC_STATUS  = 0x5327
    
    # Return values for CDROM_DRIVE_STATUS ioctl
    CDS_NO_INFO		    =0  	# if not implemented
    CDS_NO_DISC		    =1
    CDS_TRAY_OPEN		=2
    CDS_DRIVE_NOT_READY	=3
    CDS_DISC_OK		    =4
    
    # Return values for the CDROM_DISC_STATUS ioctl
    # can also return CDS_NO_[INFO|DISC], from above.
    CDS_AUDIO		=100
    CDS_DATA_1		=101
    CDS_DATA_2		=102
    CDS_XA_2_1		=103
    CDS_XA_2_2		=104
    CDS_MIXED		=105

    def noun
        "CD-ROM drive"
    end


    # FIXME
    def ready?
        return false
    end


    # Returns true if and only if the drive totally sucks.
    def drive_sucks?(drive)
        fd = File.open(drive, File::NONBLOCK | File::RDONLY)
        rv = fd.ioctl(CDROM_DRIVE_STATUS, 0);
        fd.close
        if (rv==CDS_NO_INFO)
            return true
        end
        return false
    end


    # Returns true if and only if the drive's tray is closed.
    # NOTE: Multiple states are possible; closed and loading both count here.
    def tray_closed?(drive)
        fd = File.open(drive, File::NONBLOCK | File::RDONLY)
        rv = fd.ioctl(CDROM_DRIVE_STATUS, 0);
        fd.close
        case rv
        when CDS_NO_DISC
        when CDS_DRIVE_NOT_READY
        when CDS_DISC_OK
            return true
        end
        return false
    end


    # Returns true if and only if the drive's tray is open.
    # NOTE: Multiple states are possible; closed and loading are distinguished.
    def tray_open?(drive)
        fd = File.open(drive, File::NONBLOCK | File::RDONLY)
        rv = fd.ioctl(CDROM_DRIVE_STATUS, 0);
        fd.close
        if (rv==CDS_TRAY_OPEN) 
            return true
        end
        return false
    end


    # Returns true if and only if the drive's tray is closed, but the disc is
    # still being examined.  You can get stuck here on funky media.
    def disc_loading?(drive)
        fd = File.open(drive, File::NONBLOCK | File::RDONLY)
        rv = fd.ioctl(CDROM_DRIVE_STATUS, 0);
        fd.close
        if (rv==CDS_DRIVE_NOT_READY) 
            return true
        end
        return false
    end


    # Returns true if and only if:
    # 1. The tray is closed.
    # 2. A disc seems to be present.
    # 3. The drive is done examining it.
    # This does NOT mean the OS is done examining it.
    def disc_ready?(drive)
        fd = File.open(drive, File::NONBLOCK | File::RDONLY)
        
        # Check the drive itself.
        rv = fd.ioctl(CDROM_DRIVE_STATUS, 0);
        fd.close
        if (rv==CDS_DISC_OK)
            return true
        end
    
        return false
    end

    # Returns true if and only if:
    # 1. The tray is closed.
    # 2. A disc seems to be present.
    # 3. The drive is done examining it.
    # 4. The disc is blank.
    def disc_blank?(drive)
        fd = File.open(drive, File::NONBLOCK | File::RDONLY)
        
        # Check the drive itself.
        rv = fd.ioctl(CDROM_DRIVE_STATUS, 0);
        if (rv!=CDS_DISC_OK)
            fd.close
            return false
        end

        # Now check the disc type.
        rv = fd.ioctl(CDROM_DISC_STATUS, 0);
        fd.close
        case rv 
        when CDS_NO_INFO
            return true;
        end
    
        return false
    end


    # Returns a short string describing the disc type.
    def get_content_type(drive)
        if !disc_ready?(drive)
            return "NOT READY"
        end

        if disc_blank?(drive)
            return "BLANK"
        end

        fd = File.open(drive, File::NONBLOCK | File::RDONLY)  
        rv = fd.ioctl(CDROM_DISC_STATUS, 0);
        fd.close

        # Possible race with above, so repeat a few cases.
        case rv 
        when CDS_NO_INFO
            return "BLANK"
        when CDS_NO_DISC
            return "NOT READY"
        when CDS_AUDIO
            return "AUDIO"
        when CDS_DATA_1, CDS_DATA_2, CDS_XA_2_1, CDS_XA_2_2
            return "DATA"
        when CDS_MIXED
            return "MIXED"
        else
            return "UNKNOWN"
        end
    end


    # Returns a string describing the disc type.
    def get_verbose_disc_type(drive)
        if !disc_ready?(drive)
            return "NOT READY"
        end

        if disc_blank?(drive)
            return "BLANK (unknown type)"
        end

        fd = File.open(drive, File::NONBLOCK | File::RDONLY)  
        rv = fd.ioctl(CDROM_DISC_STATUS, 0);
        fd.close

        # Possible race with above, so repeat a few cases.
        case rv 
        when CDS_NO_INFO
            return "BLANK (unknown type)"
        when CDS_NO_DISC
            return "NOT READY"
        when CDS_AUDIO
            return "AUDIO (Red Book CD-DA)"
        when CDS_DATA_1
            return "DATA (Yellow Book, Mode 1, Format 1)"
        when CDS_DATA_2
            return "DATA (Yellow Book, Mode 1, Format 2)"
        when CDS_XA_2_1
            return "DATA (Green Book, Mode 2, Format 1)"
        when CDS_XA_2_2
            return "DATA (Green Book, Mode 2, Format 2)"
        when CDS_MIXED
            return "MIXED (Vomit Book)"
        else
            return "FUCKED!"
        end

    end


    def open_tray(drive)
        if tray_open?(drive)
            log "Looks like drive #{drive} already has the tray open; leaving it that way."
        else
            log "Ejecting any disc currently in drive #{drive}..."
            startsec=Time.now
            `eject #{drive}`
            # Allow up to five seconds for the drive to eject.
            loop do
                if tray_open?(drive)
                    break
                end
        
                if Time.now-startsec > 5
                    fault("Couldn't get drive #{drive} to eject the tray/caddy/cartridge.  Check for something weird.")
                end
            end
        end
        log "OK, tray seems to be open."  
    end


    def close_tray(drive)
        if tray_closed?(drive)
            log "Looks like drive #{drive} already has the tray closed; leaving it that way."
        else
            log "Closing the tray for drive #{drive}..."
            startsec=Time.now
            `eject -t #{drive}`
            # Allow up to five seconds for the drive to close the tray.
            loop do
                if tray_closed?(drive)
                    break
                end
        
                if Time.now-startsec > 5
                    fault("Couldn't get drive #{drive} to eject the tray/caddy/cartridge.  Check for something weird.")
                end
            end
        end
        log "OK, tray seems to be closed."  
    end


    # Strictly speaking, this may not be quite correct, but it should do for now.
    def eject(drive)
        open_tray(drive)
    end


    # Wait up to timeout seconds for a disc to become ready to work with.
    def wait_for_disc(drive, timeout_in_seconds)
        start=Time.now
        loop do
            if ($exit_requested)
                warn "Exit requested; shutting down..."
                exit -1
            end

            if (Time.now-start > timeout_in_seconds)
                return false
            end

            if $extraverbose
                puts "Tray open?    " + tray_open?(actual_device).to_s
                puts "Tray closed?  " + tray_closed?(actual_device).to_s
                puts "Disc loading? " + disc_loading?(actual_device).to_s
                puts "Disc ready?   " + disc_ready?(actual_device).to_s
                puts "Disc type?    " + get_verbose_disc_type(actual_device)
                puts ""
            end

            if disc_ready?(actual_device)
                return true
            end
            sleep 1
        end
    end

    def glance(drive)
        summary = {
            'device'        => drive,
            'content_type'  => get_content_type(drive)
        }
    
        case summary['content_type']
        when "AUDIO"
            summary['has_audio']=true
            summary['has_data']=false
        when "DATA"
            summary['has_audio']=false
            summary['has_data']=true
        when "MIXED"
            summary['has_audio']=true
            summary['has_data']=true
        else
            throw "Bad content_type"
        end
    
        # Use blkid to try and get basic structure.
        blkid_hash={}
        blkid_out = `blkid /dev/sr0 --probe --info -o export`
        blkid_out.split("\n").each do |line|
            if line.include?("=")
                pair=line.split("=")
                blkid_hash[pair[0]]=pair[1]
            end
        end
    
        if $extraverbose
            log "Dumping blkid output..."
            blkid_hash.each do |key, value|
                log "blkid: " + key.cyan + " = " + value.magenta
            end
        end
    
        # Map blkid output to summary hash.
        if blkid_hash.has_key?("TYPE")
            summary['filesystem_type'] = blkid_hash['TYPE']
        else
            summary['filesystem_type'] = blkid_hash['UNKNOWN']
        end
    
        iso_info_hash={}
        case summary['filesystem_type']
        when 'iso9660','udf'
            # Use iso-info to interrogate ISO-9660 CD details, if we can.
            iso_info_out = `iso-info /dev/sr0`
            got_header=false
            iso_info_out.split("\n").each do |line|
                # Skip the copyright header.
                if line.include?("_____________________")
                    got_header=true
                end
                if got_header and line.include?(":")
                    pair=line.split(':')
                    pair[0].strip!
                    pair[1].strip!
                    iso_info_hash[pair[0]]=pair[1]
                end
            end
        end
    
        if $extraverbose
            log "Dumping iso-info output..."
            iso_info_hash.each do |key, value|
                log "iso_info: " + key.cyan + " = " + value.magenta
            end
        end
    
        return summary
    end
        
end


