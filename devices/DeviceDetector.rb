# cruftmaster/devices/DeviceDetector.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

require './liaisons/GetLiaison.rb'

def detect_device(device_path)
    # use hwinfo --cdrom to figure out what drives are available, and what kind they are.
    hwinfo = get_liaison('hwinfo')

    hwinfo_results=hwinfo.run('identify device')

    puts hwinfo_results

#    command = "hwinfo --block --only #{device_path}"
#    puts command
    #hwinfo_out = `#{command}`
    # Find the features line, and rule drive generations and feature sets in or out.
    
end


