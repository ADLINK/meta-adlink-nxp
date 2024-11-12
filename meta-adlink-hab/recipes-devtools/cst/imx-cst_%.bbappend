do_install:append () {
    # hab srktool scripts
    install -m 755 ${S}/code/hab_srktool_scripts/createSRKFuses ${D}${bindir}
    install -m 755 ${S}/code/hab_srktool_scripts/createSRKTable ${D}${bindir}
    # keys related scripts
    install -m 755 ${S}/keys/add_key.sh ${D}${bindir}
    install -m 755 ${S}/keys/ahab_pki_tree.sh ${D}${bindir}
    install -m 755 ${S}/keys/hab4_pki_tree.sh ${D}${bindir}
    # ca confs, openssl.cnf, v3_ca.cnf, v3_usr.cnf
    install -d ${D}${datadir}/ca
    install -m 644 ${S}/ca/openssl.cnf ${D}${datadir}/ca
    install -m 644 ${S}/ca/v3_ca.cnf ${D}${datadir}/ca
    install -m 644 ${S}/ca/v3_usr.cnf ${D}${datadir}/ca
}

FILES:${PN} += "${datadir}/ca"
