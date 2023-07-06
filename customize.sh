REPLACE="
"

# Taken from unlock-cn-gms
# Credit: Howard20181, yujincheng08 https://github.com/yujincheng08/unlock-cn-gms
VENDOR_PATH=$SYSTEM_PATH/vendor
OPLUS_BIGBALL_PATH=/my_bigball
OPLUS_BIGBALL_VENDOR_PATH=/mnt/vendor$OPLUS_BIGBALL_PATH
ROOT_LIST=""$SYSTEM_PATH$PERMISSIONS_PATH" "$PRODUCT_PATH$PERMISSIONS_PATH" "$VENDOR_PATH$PERMISSIONS_PATH" "$SYSTEM_EXT_PATH$PERMISSIONS_PATH" "$OPLUS_BIGBALL_PATH$PERMISSIONS_PATH" "$OPLUS_BIGBALL_VENDOR_PATH$PERMISSIONS_PATH""
FILE_LIST="services.cn.google.xml cn.google.services.xml oplus_google_cn_gms_features.xml"
for ROOT in $ROOT_LIST; do
    for FILE in $FILE_LIST; do
        if [ -f "$ROOT/$FILE" ]; then
            PERMISSION_PATH="$MODPATH$ROOT"
            FILE_NAME=$FILE
            ui_print "- PATH $ROOT/$FILE_NAME"
            mkdir -p "$PERMISSION_PATH"
            cat >"$PERMISSION_PATH/$FILE_NAME" <<EOF
<?xml version="1.0" encoding="utf-8"?>
<!-- This is the standard set of features for devices that support the CN GMSCore. -->
EOF
            [ "$ROOT" = "$OPLUS_BIGBALL_PATH$PERMISSIONS_PATH" ] || [ "$ROOT" = "$OPLUS_BIGBALL_VENDOR_PATH$PERMISSIONS_PATH" ]  && {
                if [ ! -f "$MODPATH/post-fs-data.sh" ]; then
                    cat >"$MODPATH/post-fs-data.sh" <<EOF
#!/system/bin/sh
MODDIR=\${0%/*}
EOF
                fi
                echo "mount -o ro,bind \$MODDIR$ROOT/$FILE_NAME $ROOT/$FILE_NAME" >> "$MODPATH/post-fs-data.sh"
            }
        fi
    done
done

DEF_DIALER=`cmd package resolve-activity --brief -a android.intent.action.DIAL | grep com.google.android.dialer`
if [ -n "$DEF_DIALER" ]; then
    cp -a ${MODPATH}/cn2g-optional/GmsConfigOverlayComms.apk ${MODPATH}/xml/overlay/GmsConfigOverlayComms.apk
    ui_print ""
    ui_print "******⚠注意⚠******"
    ui_print "Google 電話アプリを必ずデフォルトの電話アプリに"
    ui_print "設定して、権限や通知、自動起動を設定してください。"
    ui_print "設定していないと受話できなくなります。"
    ui_print "******⚠注意⚠******"
    ui_print ""
    ui_print ""
    ui_print "******⚠ WARNING ⚠******"
    ui_print "Please set Google Phone app as default-"
    ui_print "phone app and setup permissions / autostart."
    ui_print "If you don't, you can't receive a call."
    ui_print "******⚠ WARNING ⚠******"
    ui_print ""
fi

rm -rf ${MODPATH}/cn2g-optional

DISP_XML="/my_product/vendor/etc/multimedia_display_feature_config.xml"
#if [ -e "$DISP_XML" ]; then
#    cp -a "$DISP_XML" ${MODPATH}/xml/multimedia_display_feature_config.xml
#    sed -i 's@\<!\[CDATA\[@@g' ${MODPATH}/xml/multimedia_display_feature_config.xml
#    sed -i 's@\]\]\>@@g' ${MODPATH}/xml/multimedia_display_feature_config.xml
#fi

MEMC_XML="multimedia_pixelworks_game_apps.xml"
if [ -e /my_product/vendor/etc/${MEMC_XML} ]; then
    cp -a /my_product/vendor/etc/${MEMC_XML} ${MODPATH}/xml/${MEMC_XML}
    sed -i 's@</filter-conf>@<mConfigPackage  type="267-4-3">com.miHoYo.GenshinImpact</mConfigPackage>\n<mConfigSRPackage  type="273-1-3">com.miHoYo.GenshinImpact</mConfigSRPackage>\n<mConfigIMVPackage  type="258-10-99-18-99-3-45">com.miHoYo.GenshinImpact</mConfigIMVPackage>\n<mConfigPackage  type="267-4-3">com.google.android.youtube</mConfigPackage>\n<mConfigSRPackage  type="273-1-3">com.google.android.youtube</mConfigSRPackage>\n<mConfigIMVPackage  type="258-10-99-18-99-3-45">com.google.android.youtube</mConfigIMVPackage>\n<mConfigIMVPackage  type="258-10-99-18-99-3-45">com.amazon.avod.thirdpartyclient</mConfigIMVPackage>\n</filter-conf>@g' ${MODPATH}/xml/${MEMC_XML}
fi
