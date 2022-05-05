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
#; 12000 = > delay = 0,149 s
delay_const = 0.025
last_note = None
delay_s = 0
for x in mid.tracks[0]:
    if x.type == 'note_on':
        if x.velocity != 0:
            note['wait'] = x.time
            note['freq'] = int(noteToFreq(x.note))
        if x.velocity == 0:
            note['dur'] = x.time
            if note['wait']>4:
                #time.sleep(note['wait'] * pause_time_scale / 1000)
                delay_s = int(note['wait'] * pause_time_scale / (1000 * delay_const))
            else:
                #time.sleep(0.01)
                delay_s = 1
            if delay_s:
                print(f"    dw 0\n\r    db {delay_s}")
                delay_s = 0
            note_length = int(note['dur'] * note_time_scale / (1000 * delay_const))
            #print(f" dur = {note['dur']}")
            #cmd = f"play -n synth {note_length} sine {note['freq']} vol 0.5"
            #os.system(cmd)
            coef = int(1770000 / note['freq'])
            print(f"    dw {coef}\n\r    db {note_length}")
            last_note = note

