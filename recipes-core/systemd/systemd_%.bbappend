FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

# the following does not apply
# file://0020-logind.conf-Set-HandlePowerKey-to-ignore.patch

SRC_URI += " \
            file://0001-units-add-dependencies-to-avoid-conflict-between-con.patch \
"
