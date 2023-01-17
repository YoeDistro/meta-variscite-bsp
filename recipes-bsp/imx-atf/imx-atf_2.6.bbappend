FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:mx8-nxp-bsp = "git://github.com/varigit/imx-atf;protocol=https;branch=${SRCBRANCH} \
           file://0001-Makefile-Suppress-array-bounds-error.patch \
           file://rwx-segments.patch \
"
SRCBRANCH:mx8-nxp-bsp = "lf_v2.6_var01"
SRCREV:mx8-nxp-bsp = "b15d97961fd1a921624a645aef9f2e10ef54b36c"

EXTRA_OEMAKE:append:imx8mq-var-dart = " \
    BL32_BASE=${TEE_LOAD_ADDR} \
"

EXTRA_OEMAKE:append:imx8mm-var-dart = " \
    BL32_BASE=${TEE_LOAD_ADDR} \
"
