# HA Media Player
A Home Assistant addon that runs a headless VLC instance to use in conjunction with the [VLC Telnet integration](https://www.home-assistant.io/integrations/vlc_telnet/). There are 2 instances of this addon - one for each output created by HAOS Audio Splitter.

### Disclosure
This was heavily assisted by Github Copilot. I'm not a developer and don't really know what I'm doing, so use at your own risk. I probably won't be updating or repairing this unless it breaks for me or I need too add features (eg extra channels) in the future.

## Configuration Options

Password and port can be user configured in the addon configuration. The defaults are below. The default port for each instance is different and will need to remain so if changing from the default.

telnet_password: vlcpass
telnet_port: 4212

The addon uses host audio and any audio device available to the Home Assistant OS host should be available. If using with the HAOS Audio Splitter, select one of the two remapped devices.