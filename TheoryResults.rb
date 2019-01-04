# TheoryResults.rb
#
# Copyright (c)2018-2019 Hard Problems Group, LLC
# Released under the MIT License.
# For details, please see:
# https://cruftmaster.hardproblemsgroup.com
#
# This is a simple struct that is used to hold the names recommended by the
# various disc evaluators, called "theories".  Theories are used to try and
# come up with both a meaningful name for the disc, in case the label is
# missing or worthless, and also to help organize the archive.

TheoryResults = Struct.new(:theory_name, :confidence, :best_label, :newest_date, :category, :subcategory)
