FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SC_FIRMWARE_NAME:imx8qxp-var-som = "mx8qx-var-som-scfw-tcm.bin"
SC_FIRMWARE_NAME:imx8qxpb0-var-som = "mx8qx-var-som-scfw-tcm.bin"
SC_FIRMWARE_NAME:imx8qm-var-som = "mx8qm-var-som-scfw-tcm.bin"

SC_MX_FAMILY ?= "INVALID"
SC_MX8_FAMILY:mx8qm-nxp-bsp = "qm"
SC_MX8_FAMILY:mx8qxp-nxp-bsp = "qx"
SC_MACHINE_NAME = "mx8${SC_MX8_FAMILY}_b0"

SCFW_BRANCH = "1.15.0"
SRCREV = "0d938f5c0d6d3e8423154d3383570e4ae1647fa3"

SRC_URI += " \
    git://github.com/varigit/imx-sc-firmware.git;protocol=https;branch=${SCFW_BRANCH}; \
    https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2;name=gcc-arm-none-eabi \
"

SRC_URI[gcc-arm-none-eabi.md5sum] = "f55f90d483ddb3bcf4dae5882c2094cd"
SRC_URI[gcc-arm-none-eabi.sha256sum] = "fb31fbdfe08406ece43eef5df623c0b2deb8b53e405e2c878300f7a1f303ee52"

unset do_compile[noexec]

do_compile() {
    export TOOLS=${UNPACKDIR}
    cd ${UNPACKDIR}/git/src/scfw_export_${SC_MACHINE_NAME}/
    oe_runmake clean-${SC_MX8_FAMILY}
    oe_runmake ${SC_MX8_FAMILY} R=B0 B=var_som V=1
    cp ${UNPACKDIR}/git/src/scfw_export_${SC_MACHINE_NAME}/build_${SC_MACHINE_NAME}/scfw_tcm.bin ${S}/${SC_FIRMWARE_NAME}
}
