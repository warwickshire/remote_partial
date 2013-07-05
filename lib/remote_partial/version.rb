module RemotePartial
  VERSION = "0.2.0"
end

# History
# =======
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

