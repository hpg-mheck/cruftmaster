# garnets/virtual.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# Adds an analog for pure virtual functions.  This really just shortcuts
# some exception throws.
# 
# TO USE:
#
# class FooBase
#    virtual :some_method, :some_other_method
# end
#
# class Derived < FooBase
#    def some_method
#       puts "yadda"
#    end
# end

class PureVirtualMethodError < RuntimeError
    def intialize(classname, methodname)
        super("ERROR: Class #{classname} does not define pure virtual function #{methodname}.")
    end
end

# Mix the new keyword into the special "Module" class as a new method, making
# it available to classes.
class Module
    def virtual(*methods)
        methods.each do |method|
# FIXME - THIS DOES NOT WORK
            define_method(method) { raise PureVirtualMethodError, name(), method }
        end
    end
end

