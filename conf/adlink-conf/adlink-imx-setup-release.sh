#!/bin/sh

CWD=$(pwd)
DISTRO_NAME="$DISTRO"
MACHINE_NAME="$MACHINE"

if [ "$DISTRO" = "imx-desktop-xwayland" ]; then
	PROGNAME="$CWD/imx-setup-desktop.sh"
else
	PROGNAME="$CWD/imx-setup-release.sh"
fi

if [ -z "$BUILD" ]; then
	BUILD="build"
fi

MACHINE=$MACHINE DISTRO=$DISTRO BUILD_DIR=$BUILD source $PROGNAME $@

if [ -f ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/bblayers.conf.append ]; then
	cat ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/bblayers.conf.append >> ./conf/bblayers.conf
fi
if [ -f ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/local.conf.append ]; then
	cat ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/local.conf.append >> ./conf/local.conf
fi

if [ ! "$DISTRO" = "adlink" ]; then
	echo "IMAGE_FEATURES[validitems] += \"kiosk-mode hab remote logo resize locale lamp\"" >> ./conf/local.conf
fi

if [ -d ../sources/meta-nxp-desktop ]; then
	if ! grep -q meta-nxp-desktop ./conf/bblayers.conf; then
		echo "BBLAYERS += \"\${BSPDIR}/sources/meta-nxp-desktop\"" >> ./conf/bblayers.conf
	fi
	if [ "${DISTRO_NAME}" = "imx-desktop-xwayland" ]; then
		cat ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/desktop.local.conf.append >> ./conf/local.conf
		echo "RDEPENDS:qtbase:remove=\"vulkan-loader\"" >> ./conf/local.conf
		echo "RDEPENDS:qtbase:append=\" libvulkan-imx\"" >> ./conf/local.conf
	fi
else
	echo "BBMASK += \"imx-image-desktop.bbappend\"" >> ./conf/local.conf
	echo "BBMASK += \"ubuntu-base_%.bbappend\"" >> ./conf/local.conf
fi

if [ "$MULTILIB" = "lib32" ]; then
	cat ../sources/meta-adlink-nxp/conf/adlink-conf/$MACHINE/multilib.local.conf.append >> ./conf/local.conf
fi

if [ ! "${DISTRO_NAME}" = "adlink-rtedge-desktop" ]; then
	echo "BBMASK += \"rteval_%.bbappend\"" >> ./conf/local.conf
fi

# nxp-wlan-sdk bbappend is not buildable, mask it
echo "BBMASK += \"nxp-wlan-sdk_%.bbappend\"" >> ./conf/local.conf


# Enable meta-eiq-genai-flow layer if ENABLE_SOME_LAYER is set
if [ "$NEUTRON_EIQ_DEMO" = "1" ]; then
    echo "Enabling meta-eiq-genai-flow layer for Neutron support..."
 
    # Add the layer path to bblayers.conf if not already present
    if ! grep -q "meta-eiq-genai-flow" ./conf/bblayers.conf; then
        echo "BBLAYERS += \"\${BSPDIR}/sources/dm-eiq-genai-flow-demonstrator/meta-eiq-genai-flow\"" >> ./conf/bblayers.conf
    fi

    if ! grep -q "meta-adlink-eiq-genai-flow" ./conf/bblayers.conf; then
        echo "BBLAYERS += \"\${BSPDIR}/sources/meta-adlink-eiq-genai-flow\"" >> ./conf/bblayers.conf
    fi

 
    # Set Neutron support in local.conf
    echo "NEUTRON_SUPPORT = \"1\"" >> ./conf/local.conf
    
   # Add packages for Neutron EIQ demo
    echo 'IMAGE_INSTALL:append = " alsa-lib-dev eiq-genai-flow-dep"' >> ./conf/local.conf

    # Mask unwanted bbappend for Neutron support
    echo "BBMASK += \".*meta-eiq-genai-flow.*/linux-imx_6.12.bbappend\"" >> ./conf/local.conf

    echo "BBMASK += \"dm-eiq-genai-flow-demonstrator/meta-eiq-genai-flow/recipes-libraries/neutron/neutron_1.0.0.bbappend\"" >> ./conf/local.conf

    echo "BBMASK += \".*meta-eiq-genai-flow.*/imx-image-full-eiq-genai-flow-dep.bb\"" >> ./conf/local.conf
    
     #Automatically add scarthgap compatibility to layer.conf
    export BSPDIR="$(pwd)"
# Path to the layer.conf file
    LCONF="${BSPDIR}/../sources/dm-eiq-genai-flow-demonstrator/meta-eiq-genai-flow/conf/layer.conf"

# Check if file exists
    if [ -f "$LCONF" ]; then
    # Check if the line exists
    if grep -q 'LAYERSERIES_COMPAT_meta-eiq-genai-flow' "$LCONF"; then
        # Only add 'scarthgap' if it's not already there
        if ! grep -q 'scarthgap' "$LCONF"; then
            sed -i 's/\(LAYERSERIES_COMPAT_meta-eiq-genai-flow *= *"[^"]*\)"/\1 scarthgap"/' "$LCONF"
            echo "scarthgap added to existing LAYERSERIES_COMPAT"
        else
            echo "scarthgap already present, no changes made"
        fi
    else
        # Add a new line if LAYERSERIES_COMPAT is missing
        echo '' >> "$LCONF"
        echo 'LAYERSERIES_COMPAT_meta-eiq-genai-flow = "scarthgap"' >> "$LCONF"
        echo "Added new LAYERSERIES_COMPAT line with scarthgap"
    fi
else
    echo "$LCONF not found. Skipping patch."
fi

fi


# hook the nxp hab boot stuff
if [ "$HAB" = "1" ]; then
	echo "IMAGE_FEATURES[validitems] += \"hab\"" >> ./conf/local.conf
	echo "EXTRA_IMAGE_FEATURES:append = \" hab \"" >> ./conf/local.conf
	hook_in_layer meta-adlink-nxp/meta-adlink-hab
	case "$MACHINE" in
	*mx8m*)
		echo "HAB_VER = \"habv4\"" >> ./conf/local.conf
		;;
	*)
		echo "HAB_VER = \"ahab\"" >> ./conf/local.conf
		;;
	esac
fi

