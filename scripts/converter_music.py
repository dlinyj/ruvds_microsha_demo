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
#delay_const = 0.025
delay_const = 0.05
last_note = None
delay_s = 0
fp_melody = open('../scetches/melody.asm', 'w')
fp_melody.write('melody:\n')
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
                fp_melody.write(f"    dw 0\n    db {delay_s}\n")
                delay_s = 0
            note_length = int(note['dur'] * note_time_scale / (1000 * delay_const))
            #print(f" dur = {note['dur']}")
            #cmd = f"play -n synth {note_length} sine {note['freq']} vol 0.5"
            #os.system(cmd)
            coef = int(1770000 / note['freq'])
            fp_melody.write(f"    dw {coef}\n    db {note_length}\n")
            last_note = note

fp_melody.write('end_melody:')
fp_melody.close()
