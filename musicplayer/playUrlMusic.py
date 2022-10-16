import requests
import pyaudio  # must install this or permission error
from pydub import AudioSegment
from pydub.playback import play
import io
import argparse


def play_url(url):
    req = requests.get(url)
    # 直接播放通过url拿到的mp3 bytes文件流
    data = req.content
    song = AudioSegment.from_file(io.BytesIO(data), format="mp3")
    play(song)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-u", "--url", type=str, help='music stream url', required=True)
    args = parser.parse_args()
    play_url(args.url)
    # http://isure.stream.qqmusic.qq.com/M500000QqezO13fDGU.mp3?guid=384010402&vkey=717763134D65F0843F370D3A2B75EEF1FA4791D88A0448850E2E1A7412627784913B39D38D0663FF68B1D680B870F8D9F7440165A2BE2755&uin=&fromtag=120002
# python playUrlMusic.py -u "http://isure.stream.qqmusic.qq.com/M500000QqezO13fDGU.mp3?guid=384010402&vkey=717763134D65F0843F370D3A2B75EEF1FA4791D88A0448850E2E1A7412627784913B39D38D0663FF68B1D680B870F8D9F7440165A2BE2755&uin=&fromtag=120002"
