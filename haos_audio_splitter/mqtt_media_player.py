#!/usr/bin/env python3
import os
import sys
import json
import time
import paho.mqtt.client as mqtt
import requests
import subprocess

# Default config values
MQTT_BROKER = 'localhost'
MQTT_PORT = 1883
MQTT_USER = ''
MQTT_PASS = ''
MQTT_CLIENT_ID = 'haos_audio_splitter'
MQTT_TOPIC = 'homeassistant/media_player/haos_audio_splitter/set'
MQTT_DISCOVERY_PREFIX = 'homeassistant'
AUDIO_DEVICE = 'alsa_output.usb-C-Media_Electronics_Inc._USB_Audio_Device-00.analog-stereo'

# Read MQTT config from /data/options.json if available
try:
    with open('/data/options.json') as f:
        opts = json.load(f)
        MQTT_BROKER = opts.get('mqtt_broker', MQTT_BROKER)
        MQTT_PORT = int(opts.get('mqtt_port', MQTT_PORT))
        MQTT_USER = opts.get('mqtt_user', MQTT_USER)
        MQTT_PASS = opts.get('mqtt_pass', MQTT_PASS)
        MQTT_DISCOVERY_PREFIX = opts.get('mqtt_discovery_prefix', MQTT_DISCOVERY_PREFIX)
        AUDIO_DEVICE = opts.get('audio_device', AUDIO_DEVICE)
except Exception as e:
    print(f"Could not read /data/options.json: {e}")

# Home Assistant MQTT Discovery
DISCOVERY_PAYLOAD = {
    "name": "HAOS Audio Splitter Player",
    "unique_id": "haos_audio_splitter_player",
    "command_topic": MQTT_TOPIC,
    "state_topic": MQTT_TOPIC.replace('/set', '/state'),
    "availability_topic": MQTT_TOPIC.replace('/set', '/availability'),
    "supported_features": 0,
    "device": {
        "identifiers": ["haos_audio_splitter"],
        "name": "HAOS Audio Splitter",
        "manufacturer": "Custom",
        "model": "MQTT Audio Splitter"
    }
}

DISCOVERY_TOPIC = f"{MQTT_DISCOVERY_PREFIX}/media_player/haos_audio_splitter/config"

# MQTT callbacks
def on_connect(client, userdata, flags, rc):
    print(f"Connected to MQTT broker with result code {rc}")
    client.publish(DISCOVERY_TOPIC, json.dumps(DISCOVERY_PAYLOAD), retain=True)
    client.publish(DISCOVERY_PAYLOAD["availability_topic"], "online", retain=True)
    client.subscribe(MQTT_TOPIC)

def on_message(client, userdata, msg):
    print(f"Received MQTT message: {msg.topic} {msg.payload}")
    try:
        payload = json.loads(msg.payload.decode())
        channel = payload.get("channel", "left")
        if "media_content_id" in payload:
            url = payload["media_content_id"]
            play_audio(url, channel)
    except Exception as e:
        print(f"Error handling MQTT message: {e}")

def play_audio(url, channel='left'):
    print(f"Playing audio from URL: {url}, channel: {channel}")
    try:
        r = requests.get(url, stream=True)
        r.raise_for_status()
        with open("/tmp/input_audio", "wb") as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)
        if channel == 'left':
            # Play left channel only
            ffmpeg_cmd = [
                "ffmpeg", "-y", "-i", "/tmp/input_audio", "-af", "pan=stereo|c0=FL|c1=0", "-f", "wav", "-"]
        else:
            # Play right channel only
            ffmpeg_cmd = [
                "ffmpeg", "-y", "-i", "/tmp/input_audio", "-af", "pan=stereo|c0=0|c1=FR", "-f", "wav", "-"]
        paplay_cmd = ["paplay", "--device=%s" % AUDIO_DEVICE]
        ffmpeg_proc = subprocess.Popen(ffmpeg_cmd, stdout=subprocess.PIPE)
        paplay_proc = subprocess.Popen(paplay_cmd, stdin=ffmpeg_proc.stdout)
        ffmpeg_proc.stdout.close()
        paplay_proc.communicate()
    except Exception as e:
        print(f"Error playing audio: {e}")

def main():
    client = mqtt.Client(client_id=MQTT_CLIENT_ID)
    if MQTT_USER:
        client.username_pw_set(MQTT_USER, MQTT_PASS)
    client.on_connect = on_connect
    client.on_message = on_message
    client.will_set(DISCOVERY_PAYLOAD["availability_topic"], "offline", retain=True)
    client.connect(MQTT_BROKER, MQTT_PORT, 60)
    client.loop_forever()

if __name__ == "__main__":
    main()
