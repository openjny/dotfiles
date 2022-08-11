#!/bin/bash
rm -r ~/.pulse ~/.pluse-cookie ~/.config/pulse
pulseaudio -k && sudo alsa force-reload
