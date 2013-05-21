# Snappy

Takes a snapshot with your Mac's built-in iSight/FaceTime webcam by command line.

Snappy is also able to print a message on the snapshot!

## Requirements

* MacOSX 10.6 or higher
* [MacRuby 0.11](http://macruby.org) or higher (only to compile)

## Install

    git clone git@github.com:pioz/snappy.git 
    cd snappy/
    rake
    rake install

Alternatively you can [download the executable](https://raw.github.com/pioz/snappy/master/snappy).
    
## Usage

    snappy path/to/save/file.jpg
    
To print a message on the snapshot use:

    snappy -m "I'm Pioz" path/to/save/file.jpg

Use `-m` to print a bottom left big message, use `-t` to print a top right title.

See `snappy -h` to get more help.

![Have fun with Snappy](http://www.pioz.it/extra/snappy.jpg)

## Copyright

Copyright (c) 2013 Enrico Pilotto ([@pioz](http://github.com/pioz)). See [LICENSE](https://github.com/pioz/snappy/blob/master/LICENSE) for details.