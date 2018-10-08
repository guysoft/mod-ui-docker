#!/usr/bin/env bash
echo "yay" > /tmp/start

mod-host --verbose &
pushd /home/moduser/mod-ui
     LV2_PATH=/home/moduser/mod-plugins/lv2 mod-host -p 5555 -f 5556 -v &
     MOD_SYSTEM_OUTPUT=1 MOD_DEV_ENVIRONMENT=0  LV2_PATH=/home/moduser/mod-plugins/lv2 python3 ./server.py
popd
