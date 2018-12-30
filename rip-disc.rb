#!/usr/bin/ruby

$CDROM_DRIVE_STATUS = 0x5326
$CDROM_DISC_STATUS  = 0x5327

# Return values for CDROM_DRIVE_STATUS ioctl
$CDS_NO_INFO		    =0  	# if not implemented
$CDS_NO_DISC		    =1
$CDS_TRAY_OPEN		    =2
$CDS_DRIVE_NOT_READY	=3
$CDS_DISC_OK		    =4

# Return values for the CDROM_DISC_STATUS ioctl
# can also return CDS_NO_[INFO|DISC], from above
$CDS_AUDIO		=100
$CDS_DATA_1		=101
$CDS_DATA_2		=102
$CDS_XA_2_1		=103
$CDS_XA_2_2		=104
$CDS_MIXED		=105

begin 
    require "colorize"
rescue LoadError
    puts "FAULT: cruftmaster requires the 'colorize' gem.  Try: 'gem install colorize'."
    exit -1
end

def nowstr
    `date +%Y%m%d%Z%H%M%S`.strip
end

$ripdev="/dev/sr0"
$staging="/home/mheck/mnt/DISASTER AREA/disc-archiving"
$startedat=nowstr()
$safetyfilename="#{$staging}/cruftmaster.safety"
$logfilename="#{$staging}/cruftmaster-#{$startedat}.log"

$logfile=nil

# Report a fault when the logfile has failed.
def prelogfault(x)
    STDERR.puts "FAULT: ".red+x
    STDERR.puts "Thank you for failing with cruftmaster.".red
    exit -1
end


# See if the safety file exists.
if !File.exists?("#{$staging}/cruftmaster.safety")
    prelogfault( "cruftmaster couldn't find the safety file.  This file is used to ensure an unmounted " +
           "mountpoint is not accidentally written to.  Check that the target directory, " +
           $staging.cyan+", looks correct, and that any filesystem that should be " +
           "mounted there indeed is, then run '" + "touch #{$safetyfilename}".yellow + "'.")
end


# Open the logfile.
begin
    $logfile = File.open($logfilename, "w+");
rescue 
    prelogfault "cruftmaster couldn't write to "+"#{$logfilename}".colorize("cyan")+", committing seppuku with a spork"
    exit -1
end


def log(x)
    begin
        puts (nowstr()+": ").cyan+x
        $logfile.puts (nowstr()+": ").cyan()+x
    rescue 
        STDERR.puts "FAULT: cruftmaster couldn't write to #{$logfilename}; disk full?".red
        exit -1
    end       
end

def prompt(x)
    begin
        puts (nowstr()+": ").cyan+x.purple
        $logfile.puts (nowstr()+": ").cyan+": "+x.purple
    rescue 
        STDERR.puts "FAULT: cruftmaster couldn't write to #{$logfilename}; disk full?".red
        exit -1
    end       
end

def warn(x)
    begin
        puts (nowstr()+": ").cyan+("WARNING: ".yellow)+x
        $logfile.puts (nowstr()+": ").cyan+(": "+x)
    rescue 
        STDERR.puts "FAULT: cruftmaster couldn't write to #{$logfilename}; disk full?".red
        exit -1
    end       
end


def fault(x)
    STDERR.puts "FAULT: ".red+x
    STDERR.puts "Thank you for failing with cruftmaster.".red
    logfile.puts "FAULT: ".red+x
    logfile.puts "Thank you for failing with cruftmaster.".red
    exit -1
end

# Returns true if and only if the drive totally sucks.
def drive_sucks?(drive)
    fd = File.open(drive, File::NONBLOCK | File::RDONLY)
    rv = fd.ioctl($CDROM_DRIVE_STATUS, 0);
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
    rv = fd.ioctl($CDROM_DRIVE_STATUS, 0);
    fd.close
    case rv
    when $CDS_NO_DISC
    when $CDS_DRIVE_NOT_READY
    when $CDS_DISC_OK
        return true
    end
    return false
end


# Returns true if and only if the drive's tray is open.
# NOTE: Multiple states are possible; closed and loading are distinguished.
def tray_open?(drive)
    fd = File.open(drive, File::NONBLOCK | File::RDONLY)
    rv = fd.ioctl($CDROM_DRIVE_STATUS, 0);
    fd.close
    if (rv==$CDS_TRAY_OPEN) 
        return true
    end
    return false
end


# Returns true if and only if the drive's tray is closed, but the disc is
# still being examined.  You can get stuck here on funky media.
def disc_loading?(drive)
    fd = File.open(drive, File::NONBLOCK | File::RDONLY)
    rv = fd.ioctl($CDROM_DRIVE_STATUS, 0);
    fd.close
    if (rv==$CDS_DRIVE_NOT_READY) 
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
    rv = fd.ioctl($CDROM_DRIVE_STATUS, 0);
    fd.close
    if (rv==$CDS_DISC_OK)
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
    rv = fd.ioctl($CDROM_DRIVE_STATUS, 0);
    if (rv!=$CDS_DISC_OK)
        fd.close
        return false
    end

    # Now check the disc type.
    rv = fd.ioctl($CDROM_DISC_STATUS, 0);
    fd.close
    case rv 
    when $CDS_NO_INFO
        return true;
    end
   
    return false
end


# Returns a string describing the disc type.
def get_disc_type(drive)
    if !disc_ready?(drive)
        return "NOT READY"
    end

    if disc_blank?(drive)
        return "BLANK (unknown type)"
    end

    fd = File.open(drive, File::NONBLOCK | File::RDONLY)  
    rv = fd.ioctl($CDROM_DISC_STATUS, 0);
    fd.close

    # Possible race with above, so repeat a few cases.
    case rv 
    when $CDS_NO_INFO
        return "BLANK (unknown type)"
    when $CDS_NO_DISC
        return "NOT READY"
    when $CDS_AUDIO
        return "AUDIO (Red Book CD-DA)"
    when $CDS_DATA_1
        return "DATA (Yellow Book, Mode 1, Format 1)"
    when $CDS_DATA_2
        return "DATA (Yellow Book, Mode 1, Format 2)"
    when $CDS_XA_2_1
        return "DATA (Green Book, Mode 2, Format 1)"
    when $CDS_XA_2_2
        return "DATA (Green Book, Mode 2, Format 2)"
    when $CDS_MIXED
        return "MIXED (Vomit Book)"
    else
        return "FUCKED!"
    end

end


log "Reluctantly beginning operations.  Oh no, not again.".green

log "Ejecting any disc currently in the drive..."
`eject`
if (tray_open?($ripdev))
    log "OK, tray seems to be open, good..."
else
    log "Eject command completed, but tray doesn't seem to be open yet, kind of dumb..."
end
log "Waiting five seconds to see if the drive does anything stupid..."
sleep 5

$exit_requested=false
def MainLoop
    # Install CTRL-C handler
    Kernel.trap("INT") {
        warn "Caught CTRL-C, requesting exit..."
        $exit_requested=true; 
    }

    log "Put a disc in the drive, or piss off..."
    while ((!$exit_requested) && (!disc_ready?($ripdev)))
        sleep 1
        puts "Tray open?    " + tray_open?($ripdev).to_s
        puts "Tray closed?  " + tray_closed?($ripdev).to_s
        puts "Disc loading? " + disc_loading?($ripdev).to_s
        puts "Disc ready?   " + disc_ready?($ripdev).to_s
        puts "Disc type?    " + get_disc_type($ripdev)
        puts ""
    end
end

MainLoop()

ENDEDAT=nowstr()
log "Ending operations.  Have a nice daycycle."
$logfile.close
