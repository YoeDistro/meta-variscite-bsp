SUMMARY = "Copy U-Boot's splash.bmp to rootfs"
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"
SECTION = "bootloader"

SRC_URI = "file://splash.bmp"

FILES:${PN} = "/boot/splash.bmp"

do_install () {
	install -d ${D}/boot
	install -m 644 ${UNPACKDIR}/splash.bmp ${D}/boot/splash.bmp
}
