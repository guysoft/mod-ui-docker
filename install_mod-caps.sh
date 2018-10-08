# install_mod-caps.sh
cd $ZYNTHIAN_PLUGINS_SRC_DIR
git clone https://github.com/moddevices/caps-lv2.git
cd caps-lv2
sed 's/pow10f/exp10f/g' dsp/v4f_IIR2.h -i
make -j 4
 cp -R plugins/* $ZYNTHIAN_PLUGINS_DIR/lv2
make clean
cd ..
