# media/Media.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Media
# -----
# This is the base Media class, which defines some methods that other media
# types need to redefine for proper performance.

class Media
    # Returns the maximum operating shock of the media.  The actual maximum
    # operating shock specification for a storage solution is the lower
    # between the drive and the media.
    def MaximumOperatingShockInGs
        return nil
    end

    # Returns the maximum non-operating (storage) shock of the media.  The
    # actual maximum non-operating shock specification for a storage solution
    # is the lower rating between the drive and the media.
    def MaximumStorageShockInGs
        return nil
    end

    # Returns the minimum non-operating (storage) temperature of the media.
    def MinimumStorageTemperatureInCelsius
        return nil
    end

    # Returns the ideal non-operating (storage) temperature of the media.
    def IdealStorageTemperatureInCelsius
        return nil
    end

    # Returns the maximum non-operating (storage) temperature of the media.
    def MaximumStorageTemperatureInCelsius
        return nil
    end

    # Returns the minimum operating temperature of the media.
    def MinimumOperatingTemperatureInCelsius
        return nil
    end

    # Returns the maximum operating temperature of the media.
    def MaximumOperatingTemperatureInCelsius
        return nil
    end

    # Returns the ideal operating temperature of the media.
    def IdealOperatingTemperatureInCelsius
        return nil
    end

    # Returns the maxium temperature gradient that can exist across the media,
    # expressed as degrees Celsius difference per centimeter, while operating.
    # For tapes, this is measured across a wound reel.
    def MaximumOperatingThermalGradient
        return nil
    end

    # Returns the maxium temperature gradient that can exist across the media,
    # expressed as degrees Celsius difference per centimeter, in storage.
    # For tapes, this is measured across a wound reel.
    def MaximumStorageThermalGradient
        return nil
    end

    # Returns the maximum rate at which it is safe for the medium to change
    # temperature, in degrees Celsius per second, while operating.  This
    # value tends to be different at the top and bottom ends of the temperature
    # range; this function returns the worst-case value.
    def MaximumOperatingThermalSlewRate
        return nil
    end
    
    # Returns the maximum rate at which it is safe for the medium to change
    # temperature, in degrees Celsius per second, in storage.  This value
    # tends to be different at the top and bottom ends of the temperature
    # range; this function returns the worst-case value.
    def MaximumStorageThermalSlewRate
        return nil
    end
    
    # Returns the minimum non-operating (storage) humidity of the media.
    def MinimumStorageHumidityInCelsius
        return nil
    end

    # Returns the ideal non-operating (storage) humidity of the media.
    def IdealStorageHumidityInCelsius
        return nil
    end

    # Returns the maximum non-operating (storage) humidity of the media.
    def MaximumStorageHumidityInCelsius
        return nil
    end

    # Returns the maximum non-operating (storage) rate of humidity change for
    # the media, expressed as the absolute change in percent relative humidity
    # (%RH) of the media's immediate environment, per second.
    def MaximumStorageHumiditySlewRate
        return nil
    end

    # Returns the minimum operating humidity of the media.
    def MinimumOperatingHumidityInCelsius
        return nil
    end

    # Returns the maximum operating humidity of the media.
    def MaximumOperatingHumidityInCelsius
        return nil
    end

    # Returns the ideal operating humidity of the media.
    def IdealOperatingHumidityInCelsius
        return nil
    end

    # Returns the maximum rate of humidity change for the media while in use,
    # expressed as the absolute change in percent relative humidity (%RH) of
    # the media's immediate environment, per second.
    def MaximumOperatingHumiditySlewRate
        return nil
    end

    # Returns the maximum environmental electric field strength, in volts per
    # meter, that the media can be exposed to without damage.
    def MaximumElectricFieldStrength
        return nil
    end

    # Returns the maximum environmental magnetic field strength, in Tesla,
    # that the media can be exposed to without damage.
    def MaximumMagneticFieldStrength
        return nil
    end

    # Returns the probable maximum lifespan of the media in years, regardless
    # of failure cause.  This will be the minimum of such factors as surface
    # oxidation, delamination, magnetic drift, cell discharge, and chemical
    # breakdown.
    def MaximumLifespanInYears
        # FIXME - minimum of lifespan_limiting_factors
        return nil
    end

    # A hash of all of the factors that limit operational lifespan.
    # Entries in this hash are themselves hashes which define three keys:
    # name (a string), value (a single-precision floating-point number,
    # defining the lifespan limit in years), and description (a string).
    @lifespan_limiting_factors={}
    
    # A hash of all of the factors that raise the single-bit error rate.
    @error_sources={}
end
