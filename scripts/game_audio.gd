extends AudioStreamPlayer
class_name GameAudio

# Efeitos sintetizados sem arquivos externos, mantendo o projeto reproduzível.
const CUES := {
	"hit": [220.0, 0.11],
	"pickup": [660.0, 0.09],
	"skill": [520.0, 0.12],
	"elimination": [165.0, 0.25],
}
var streams: Dictionary = {}

func _ready() -> void:
	volume_db = -15.0
	for cue in CUES:
		var spec: Array = CUES[cue]
		streams[cue] = make_tone(float(spec[0]), float(spec[1]))

func play_cue(cue: String) -> void:
	if not streams.has(cue):
		return
	stream = streams[cue]
	play()

static func make_tone(frequency: float, duration: float) -> AudioStreamWAV:
	var rate := 22050
	var count := int(rate * duration)
	var bytes := PackedByteArray()
	bytes.resize(count * 2)
	for i in range(count):
		var fade := 1.0 - float(i) / float(count)
		var wave := sin(TAU * frequency * float(i) / float(rate))
		bytes.encode_s16(i * 2, int(wave * fade * 12000.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = rate
	wav.stereo = false
	wav.data = bytes
	return wav
