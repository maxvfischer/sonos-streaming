# How to stream your vinyl record player to Sonos (Airplay2)
This guide is based on this Instructable guide: https://www.instructables.com/Add-Aux-to-Sonos-Using-Raspberry-Pi/

## Needed hardware
To stream the sound from a vinyl record player to the Sonos speakers, you will need:

* 1x RaspberryPi (with USB Type-A)
* 1x Behringer U-PHONE UFO202

## Overview software
The the main software used is:

**Darkice**
DarkIce is a live audio streamer. It records audio from an audio interface (e.g. sound card), 
encodes it and sends it to a streaming server. This software is used to read the vinyl signals 
coming from the U-PHONE UFO202.

URL: http://www.darkice.org

**Icecast2**
Icecast is a streaming media (audio/video) server which currently supports a MP3 streams. We're 
using it to take the live audio stream from Darkice and broadcast it out in our local network. 
This is what the Sonos speakers will pick up and play.

URL: https://icecast.org

## Set up hardware

### Set up Raspberry Pi

#### Set up static IP address
We're setting a static IP address on the Raspberry Pi to simplify SSH-ing to it.

### Connect U-PHONE UFO202

## Set up software


