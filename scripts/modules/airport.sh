#!/usr/bin/env bash

get_wifi_ssid()
{
  # Check OS
  case $(uname -s) in
    Linux)
      SSID=$(iw dev | sed -nr 's/^\t\tssid (.*)/\1/p')
      if [ -n "$SSID" ]; then
        echo "$wifi_label$SSID"
      else
        echo "$ethernet_label"
      fi
      ;;

    Darwin)
      local wifi_network=$(ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}')
      local airport=$(networksetup -getairportnetwork en0 | cut -d ':' -f 2)

      if [[ $airport != "You are not associated with an AirPort network." ]]; then
        echo "$wifi_label$airport" | sed 's/^[[:blank:]]*//g'
      elif [[ $wifi_network != "" ]]; then
        echo "$wifi_label$wifi_network" | sed 's/^[[:blank:]]*//g'
      else
        echo "$ethernet_label"
      fi
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # leaving empty - TODO - windows compatability
      ;;

    *)
      ;;
  esac

}

macos_airport_status() {
  /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I
}
get_wifi_strength() {
  macos_airport_status | grep -e "CtlRSSI" | awk -F '-' '{print $2}'
}
get_wifi_ssid

