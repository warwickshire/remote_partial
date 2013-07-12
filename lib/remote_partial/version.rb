module RemotePartial
  VERSION = "0.3.1"
end

# History
# =======
#
# 0.3.1 Remove migration file
# ---------------------------
# Migration file is no longer needed but had been left in code.
#
# 0.3.0 Partials persisted via YAML
# ---------------------------------
# Moved partial data to a YAML file to remove the dependency on ActiveRecord.
#
# A database table was being used to store partial data. However, the amount of
# data being stored is small, and adding a reliance on ActiveRecord to store
# this data was limiting where RemotePartial could be used.
#
# 0.2.1 Initial migrate issue
# ---------------------------
# As you need to load the application, before you can migrate, the
# RemotePartial.define statements would be called before the partial migration
# could be called. This would raise an error:
#
#   "Could not find table 'remote_partial_partials'".
#   
# So define has to check if a partials table exists, before running build. This
# version adds that check
#
# Also improved the way Webmock was loaded, and made some mods to make engine
# more Rails 4 friendly
#
# 0.2.0 UTF-8 Fix
# ---------------
# Fixes a fundamental flaw in earlier versions. Previously the encoding used in
# the file transfer from the remote site was not being set.
#
# Also Nokogiri was appending header information on to page, so this version
# only uses Nokogiri if part of the page needs to be extracted via criteria.
#
# 0.1.1 Remove option to alter remote_partials destination folder
# ---------------------------------------------------------------
# The functionality was not working and just added extra complication
#
# 0.1.0 First beta version
# ------------------------
# Updated following tests using a separate host app
#
# 0.0.1 Initial release
# ---------------------
# Most functionality working, but not fully tested within a separate host app
#

