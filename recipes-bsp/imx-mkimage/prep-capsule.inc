inherit python3native
DEPENDS:append = " systemready-scripts-native python3-construct-native python3-pyyaml-native python3-native"

do_prep_capsule () {
	if [ -f ${BOOT_STAGING}/capsule1.bin ]; then
		cp ${BOOT_STAGING}/capsule1.bin ${BOOT_STAGING}/signed_capsule.bin
		capsule-tool.py --debug --de-authenticate --output ${BOOT_STAGING}/unauth.bin ${BOOT_STAGING}/signed_capsule.bin
		capsule-tool.py --debug --tamper --output ${BOOT_STAGING}/tampered.bin ${BOOT_STAGING}/signed_capsule.bin
	fi
}
addtask prep_capsule before do_deploy after do_compile

do_deploy:append() {
    if ${DEPLOY_OPTEE_STMM}; then
        # Deploy STMM related files
        install -m 0644 ${BOOT_STAGING}/signed_capsule.bin  ${DEPLOYDIR}/${BOOT_TOOLS}
        install -m 0644 ${BOOT_STAGING}/unauth.bin          ${DEPLOYDIR}/${BOOT_TOOLS}
        install -m 0644 ${BOOT_STAGING}/tampered.bin        ${DEPLOYDIR}/${BOOT_TOOLS}
    fi
}

