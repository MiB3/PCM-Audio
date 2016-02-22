# PCM-Audio
Exploring and understanding basic audio compression with PCM.

## Description
This is a project which I did for the course 'Multimedia Communications' at ETH Zürich (Fall Semester 2015).
The main goal was to get a better understanding of audio compression with PCM (Pulse-Code Modulation) and G711 as a standard for audio companding. The project is written in MATLAB.

## Usage

```
[y, fs] = audioread([soundFolder 'audioFile.wav']); % read audio
y = y / max(abs(y)); % normalize to [-1, 1]

yG711 = g711(y, fs); % apply G711
sound(yG711, 8000) % play modified sound
```

## Author
Milan Bombsch

## License
The source code is provided under the MIT License.
See LICENSE.txt
