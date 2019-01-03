#!/usr/bin/ruby
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

$exit_requested=false
$verbose=false
$extraverbose=true

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
        puts (nowstr()+": ").cyan+x.magenta
        $logfile.puts (nowstr()+": ").cyan+": "+x.magenta
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
    $logfile.puts "FAULT: ".red+x
    $logfile.puts "Thank you for failing with cruftmaster.".red
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


# Returns a short string describing the disc type.
def get_content_type(drive)
    if !disc_ready?(drive)
        return "NOT READY"
    end

    if disc_blank?(drive)
        return "BLANK"
    end

    fd = File.open(drive, File::NONBLOCK | File::RDONLY)  
    rv = fd.ioctl($CDROM_DISC_STATUS, 0);
    fd.close

    # Possible race with above, so repeat a few cases.
    case rv 
    when $CDS_NO_INFO
        return "BLANK"
    when $CDS_NO_DISC
        return "NOT READY"
    when $CDS_AUDIO
        return "AUDIO"
    when $CDS_DATA_1, $CDS_DATA_2, $CDS_XA_2_1, $CDS_XA_2_2
        return "DATA"
    when $CDS_MIXED
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
            puts "Tray open?    " + tray_open?($ripdev).to_s
            puts "Tray closed?  " + tray_closed?($ripdev).to_s
            puts "Disc loading? " + disc_loading?($ripdev).to_s
            puts "Disc ready?   " + disc_ready?($ripdev).to_s
            puts "Disc type?    " + get_verbose_disc_type($ripdev)
            puts ""
        end

        if disc_ready?($ripdev)
            return true
        end
        sleep 1
    end
end


# FIXME: Use the UUID of the disc!
def get_trite_disc_nickname
    adjectives=
    [   "astounding",
    "batshit",
    "benign",
    "cracked",
    "creased",
    "crunched",
    "crippled",
    "crushed",
    "dismayed",
    "doomed",
    "flamenco-dancing",
    "folded",
    "harmless",
    "hazed",
    "inebriated",
    "inert",
    "malignant",
    "maligned",
    "marbled",
    "mutilated",
    "oblate",
    "obnoxious",
    "obsolete",
    "pathetic",
    "particular",
    "polycarbonate",
    "perky",
    "sad",
    "scored",
    "scratched",
    "screwy",
    "scuffed",
    "soul-crushing",
    "spindled",
    "spiralled",
    "splattered",
    "toothpaste-covered",
    "unbalanced",
    "verboten",
    "wafer-thin"
    ]

    nouns =
    [   "artifact",
        "chunk of your past",
        "disc",
        "donut",
        "frisbee",
        "hocky puck",
        "orblette"]
    
    description = adjectives.sample

    while [true,false].sample do
        adj = adjectives.sample
        if !description.include? adj
            description+=", "+adj
        end
    end

    description+=" "+nouns.sample
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


def consider_digital_audio
    # FIXME
    # Simple percentage of files that match extensions check.
end

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


def consider_theories(drive, summary)
    # Make a scoring hash.
    # These each have the following members:
    # 'score' : A floating-point number from 0.0 (no chance) to 1.0 (definitely) where 0.5 is "no opinion".
    # 'proposed_name' : The best name the theory can come up with.
    summary['theories']={}

    summary=consider_windows_setup(drive, summary)

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


# ################### MAIN LOOP #################### #


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


log "Reluctantly beginning operations.  Oh no, not again.".green

#eject($ripdev)
main_loop()

ENDEDAT=nowstr()
log "Ending operations.  Have a nice daycycle."
$logfile.close
