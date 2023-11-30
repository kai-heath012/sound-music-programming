MIDIIn.connect;

(
SynthDef(\pitch_detector, {
arg gate = 0;
var c = SoundIn.ar(mul:gate);
var d = Pitch.kr(c);
var env = EnvGen.kr(Env.adsr(0.01, 0, 1, 10.0), gate:d[1]);
	var sound = Pulse.ar(d[0], 0.5, 0.2*env) !2 + Pulse.ar(d[0]/1.99, 0.1, 0.5*env) !2;
var freqenv = EnvGen.kr(Env.perc(0.5, 0.5), d[1], 2000, 200);

Out.ar(0, RLPF.ar(sound, freqenv, 0.2))

}).add;
)

// Pitch control via MIDI
(
x = Synth(\pitch_detector);

MIDIdef.noteOn(\onoff, {
arg vel, num;
if(num>40, { x.set(\gate, 1); "on".postln; }, { x.set(\gate, 0); "recording/off".postln; })
});
)

//when gate is "on" take the frequency from d[0] and store it in a static variable and use that  to make the sound based on random roots and fifths 3/2
//put frequency into array

