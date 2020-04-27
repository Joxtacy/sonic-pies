# Plays binaural beats.
define :svavning do |note, *args| # synth, freq, attack, release, sustain
  defaults = {
    synth: :beep,
    freq: 1,
    attack: 12,
    release: 8,
    sustain: 0
  }

  ag = args[0]
  ag = defaults if ag == nil
  ag = defaults.merge(ag)

  use_synth ag[:synth]
  beat_note = hz_to_midi(midi_to_hz(note) + ag[:freq])

  play note, attack: ag[:attack], release: ag[:release], sustain: ag[:sustain], pan: 0.5
  play beat_note, attack: ag[:release], release: ag[:attack], sustain: ag[:sustain], pan: -0.5
end

# Plays the perc_bell sample with a random rate of (-2, 2)
# for *n* number of times with a random sleep of (0.25, 2)
# between each play.
define :haunted_bells do |n|
  with_fx :reverb do
    n.times do
      sample :perc_bell, rate: [rrand(-2, -0.035), rrand(0.035, 2)].choose
      sleep rrand(0.25, 2)
    end
  end
end

# Just a simple util function to use when trying to find
# how much more you can sleep before loop is over.
define :get_remaining_sleep do |remain, attempt|
  if remain < attempt then
    return remain
  else
    return attempt
  end
end
