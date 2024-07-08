# Copyright (C) 2017-2020 NXP
# Copyright (C) 2021 Variscite LTD

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:var-som = " \
    file://0001-iMX8M-soc-allow-dtb-override.patch \
    file://0002-iMX8M-soc-change-padding-of-DDR4-and-LPDDR4-DMEM-fir.patch \
    "

SRC_URI:append:imx8mm-var-dart = " file://0003-iMX8M-soc-add-variscite-imx8mm-support.patch"
SRC_URI:append:imx8mm-var-dart = " file://0001-iMX8M-soc-imx8mm-move-TEE_LOAD_ADDR-to-512mb-memory-.patch"
SRC_URI:append:imx8mq-var-dart = " file://0001-iMX8M-soc-imx8mq-move-TEE_LOAD_ADDR-to-512mb-memory.patch"

do_compile:var-som() {
    echo "Copying DTBs"
    if [ "mx8m" = "${SOC_FAMILY}" ]; then
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME} ${BOOT_STAGING}

        for UBOOT_DTB_EXTRA_FILE in ${UBOOT_DTB_EXTRA}; do
            cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_EXTRA_FILE} ${BOOT_STAGING}
        done
    fi

    # mkimage for i.MX8
    # Copy TEE binary to SoC target folder to mkimage
    if ${DEPLOY_OPTEE}; then
        cp ${DEPLOY_DIR_IMAGE}/tee.bin ${BOOT_STAGING}
        if ${DEPLOY_OPTEE_STMM}; then
            # Copy tee.bin to tee.bin-stmm
            cp ${DEPLOY_DIR_IMAGE}/tee.bin ${BOOT_STAGING}/tee.bin-stmm
        fi
    fi
    # Copy OEI firmware to SoC target folder to mkimage
    if [ "${OEI_ENABLE}" = "YES" ]; then
        cp ${DEPLOY_DIR_IMAGE}/${OEI_NAME}               ${BOOT_STAGING}
    fi

    for target in ${IMXBOOT_TARGETS}; do
        compile_${SOC_FAMILY}
        case $target in
        *no_v2x)
            # Special target build for i.MX 8DXL with V2X off
            bbnote "building ${IMX_BOOT_SOC_TARGET} - ${REV_OPTION} V2X=NO ${target}"
            make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} V2X=NO \
                dtbs="${UBOOT_DTB_NAME} ${UBOOT_DTB_EXTRA}" \
                flash_linux_m4
        ;;
        *stmm_capsule)
            cp ${RECIPE_SYSROOT_NATIVE}/${bindir}/mkeficapsule      ${BOOT_STAGING}
            bbnote "building ${IMX_BOOT_SOC_TARGET} - TEE=tee.bin-stmm ${target}"
            make SOC=${IMX_BOOT_SOC_TARGET} TEE=tee.bin-stmm delete_capsule_key
            make SOC=${IMX_BOOT_SOC_TARGET} TEE=tee.bin-stmm ${REV_OPTION} capsule_key
            make SOC=${IMX_BOOT_SOC_TARGET} TEE=tee.bin-stmm ${REV_OPTION} \
                dtbs="${UBOOT_DTB_NAME} ${UBOOT_DTB_EXTRA}" \
                ${target}
        ;;
        *)
            bbnote "building ${IMX_BOOT_SOC_TARGET} - ${REV_OPTION} ${target}"
            make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} \
                dtbs="${UBOOT_DTB_NAME} ${UBOOT_DTB_EXTRA}" \
                ${target}
        ;;
        esac

        if [ -e "${BOOT_STAGING}/flash.bin" ]; then
            cp ${BOOT_STAGING}/flash.bin ${S}/${BOOT_CONFIG_MACHINE}-${target}
        fi
    done
}
