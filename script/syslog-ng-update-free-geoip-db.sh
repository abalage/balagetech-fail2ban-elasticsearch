#!/bin/bash

set -o nounset
DB="GeoLite2-City.tar.gz"

TMPDIR=$(mktemp -d)
cd ${TMPDIR}

wget -q http://geolite.maxmind.com/download/geoip/database/${DB}
wget -q http://geolite.maxmind.com/download/geoip/database/${DB}.md5

MD5SUM_CREATED=$(md5sum ${DB} | cut -d" " -f1)
MD5SUM_HOSTED=$(head -n1 ${DB}.md5)

if [ ${MD5SUM_CREATED} != ${MD5SUM_HOSTED} ]; then
    echo "md5sums do not match"
    echo "'${MD5SUM_CREATED}'"
    echo "'${MD5SUM_HOSTED}'"
    exit 1
fi
tar -xf ${DB} -C ${TMPDIR}
rm ${DB}
rm ${DB}.md5
SUBDIR=$(ls -d -- */)
cd ${SUBDIR}
cp GeoLite2-City.mmdb /etc/syslog-ng/
chown root.root /etc/syslog-ng/GeoLite2-City.mmdb
systemctl reload syslog-ng
rm -rf ${TMPDIR}
