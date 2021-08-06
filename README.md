## Install Instructions

clone the `void-linux/void-packages` repo

clone this repo

copy the `libXft-bgra` folder into the `srcpkgs` folder inside of `void-packages`

type the following commands:
```
$ cd void-packages
$ ./xbps-src binary-bootstrap
$ ./xbps-src pkg libXft-bgra
# xbps-install --repository=hostdir/binpkgs libXft-bgra
```
this should immedietly replace `libXft` with `libXft-bgra`
