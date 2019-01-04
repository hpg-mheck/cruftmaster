#!/usr/bin/ruby

# humor.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com

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
