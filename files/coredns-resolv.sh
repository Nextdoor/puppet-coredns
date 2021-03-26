#!/bin/sh

# Helper function to discover the current internal domain via systemd
find_domain() {
  INTERNAL_DOMAIN="internal"
  LINKS=$(/usr/bin/busctl tree --list org.freedesktop.resolve1 | /bin/grep link/_)
  for L in $LINKS; do
      m=$(/usr/bin/busctl get-property org.freedesktop.resolve1 $L org.freedesktop.resolve1.Link Domains | /bin/grep -oP '"\K[^"\047]+(?=["\047])' | /usr/bin/head -1)
      if [ ! -z $m ]; then
        echo $m
        return
      fi
  done
}

start_resolv()
{
  rm -rf /etc/resolv.conf || true
  echo "nameserver 127.0.0.1" >> /etc/resolv.conf
  echo "search $(find_domain)" >> /etc/resolv.conf
  echo "options attempts:5 timeout:2" >> /etc/resolv.conf
  return 0
}

stop_resolv()
{
  rm -rf /etc/resolv.conf || true

  return 0
}

case "$1" in
  start)
    start_resolv
    exit 0
  ;;
  stop)
    stop_resolv
    exit 0
  ;;
esac

exit 0