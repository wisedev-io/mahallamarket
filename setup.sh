@wisedev-io ➜ /workspaces/mahallamarket (main) $ flutter devices
Found 2 connected devices:
  Linux (desktop) • linux  • linux-x64      • Ubuntu 24.04.2 LTS 6.8.0-1030-azure
  Chrome (web)    • chrome • web-javascript • unknown

Run "flutter emulators" to list and start any available device emulators.

If you expected another device to be detected, please run "flutter doctor" to diagnose
potential issues. You may also try increasing the time to wait for connected devices with
the "--device-timeout" flag. Visit https://flutter.dev/setup/ for troubleshooting tips.
@wisedev-io ➜ /workspaces/mahallamarket (main) $ flutter run -d chrome
Launching lib/main.dart on Chrome in debug mode...
Waiting for connection from debug service on Chrome...             25.8s
[CHROME]:
[CHROME]:Command '/usr/bin/chromium-browser' requires the chromium snap to be installed.
[CHROME]:Please install it with:
[CHROME]:
[CHROME]:snap install chromium
[CHROME]:
Failed to launch browser after 3 tries. Command used to launch it:
/usr/bin/chromium-browser
--user-data-dir=/tmp/flutter_tools.WJQGBX/flutter_tools_chrome_device.TFNRFW
--remote-debugging-port=35683 --disable-background-timer-throttling --disable-extensions
--disable-popup-blocking --bwsi --no-first-run --no-default-browser-check
--disable-default-apps --disable-translate http://localhost:45427
Failed to launch browser. Make sure you are using an up-to-date Chrome or Edge. Otherwise,
consider using -d web-server instead and filing an issue at
https://github.com/flutter/flutter/issues.
@wisedev-io ➜ /workspaces/mahallamarket (main) $ 