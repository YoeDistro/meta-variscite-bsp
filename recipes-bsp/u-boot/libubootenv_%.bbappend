FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LDFLAGS:append = "${@bb.utils.contains('DISTRO_FEATURES', 'ld-is-gold', " -fuse-ld=bfd ", '', d)}"
