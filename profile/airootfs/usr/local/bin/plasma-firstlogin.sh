#!/bin/bash

until qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "desktops();" &>/dev/null; do
    sleep 1
done

qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var myWallpaper = 'file:///usr/share/backgrounds/lunawolf_kde.jpg';

var allDesktops = desktops();
for (var i = 0; i < allDesktops.length; i++) {
    var d = allDesktops[i];

    d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
    var current = d.readConfig('Image', '');

    var isUnset = current === '';
    var isSystemWallpaper = current.indexOf('file:///usr/share/backgrounds/') === 0
                         || current.indexOf('file:///usr/share/wallpapers/') === 0
                         || current.indexOf('/usr/share/backgrounds/') === 0
                         || current.indexOf('/usr/share/wallpapers/') === 0;

    if (isUnset || isSystemWallpaper) {
        d.wallpaperPlugin = 'org.kde.image';
        d.writeConfig('Image', myWallpaper);
        d.writeConfig('FillMode', 0);
    }

    d.currentConfigGroup = ['General'];
	var arrangement = d.readConfig('arrangement', -1);

	if (arrangement === -1 || arrangement === 0) {
		d.writeConfig('arrangement', 1);
	}
}
"

rm ~/.config/autostart/plasma-firstlogin.desktop
