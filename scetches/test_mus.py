from mido import MidiFile
from pathlib import Path
import time
import os

def noteToFreq(note):
    a = 440 #frequency of A (coomon value is 440Hz)
    return (a / 32) * (2 ** ((note - 9) / 12))

mid = MidiFile('ppk.mid', clip=True)
print('number of tracks', len(mid.tracks))

note_time_scale = 1
pause_time_scale = 1

note = {'wait':0, 'freq':0, 'dur': 0 }

last_note = None
for x in mid.tracks[0]:
    if x.type == 'note_on':
        if x.velocity != 0:
            note['wait'] = x.time
            note['freq'] = int(noteToFreq(x.note))
        if x.velocity == 0:
            note['dur'] = x.time
            if note['wait']>4:
                time.sleep(note['wait'] * pause_time_scale / 1000)
            else:
                time.sleep(0.01)
            note_length = int(note['dur'] * note_time_scale) / 1000
            print(f" dur = {note['dur']}")
            cmd = f"play -n synth {note_length} sine {note['freq']} vol 0.5"
            os.system(cmd)
            last_note = note

