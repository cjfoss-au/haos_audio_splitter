# HAOS Audio Splitter
A Home Assistant addon (or app, as of HA release 2026.2) that splits a stereo USB audio device into two mono output channels and exposes them to HA to be used by other addons.

# HA Media Player
A Home Assistant addon that runs a headless VLC instance to use in conjunction with the [VLC Telnet integration](https://www.home-assistant.io/integrations/vlc_telnet/). There are 2 instances of this addon - one for each output created by HAOS Audio Splitter.

### Disclosure
This was heavily assisted by Github Copilot. I'm not a developer and don't really know what I'm doing, so use at your own risk. I probably won't be updating or repairing this unless it breaks for me or I need too add features (eg extra channels) in the future.