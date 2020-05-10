# Plays binaural beats.
define :svavning do |note, *args| # synth, freq, attack, release, sustain
  defaults = {
    synth: :beep,
    freq: 1,
    attack: 12,
    release: 8,
    sustain: 0,
    pan: 0.5
  }

  ag = args[0]
  ag = defaults if ag == nil
  ag = defaults.merge(ag)

  use_synth ag[:synth]
  beat_note = hz_to_midi(midi_to_hz(note) + ag[:freq])

  a = play note, attack: ag[:attack], release: ag[:release], sustain: ag[:sustain], pan: ag[:pan]
  b = play beat_note, attack: ag[:release], release: ag[:attack], sustain: ag[:sustain], pan: -ag[:pan]
  [a, b]
end

# Add *freq* Hz to the provided MIDI *note*.
# Returns a new MIDI note
define :add_freq_to_midi do |note, freq|
  f = midi_to_hz(note) + freq
  return hz_to_midi(f)
end

# Plays the perc_bell sample with a random rate of (-2, 2)
# for *n* number of times with a random sleep of (0.25, 2)
# between each play.
define :haunted_bells do |n|
  in_thread do
    with_fx :reverb do
      n.times do
        sample :perc_bell, rate: [rrand(-2, -0.035), rrand(0.035, 2)].choose
        sleep rrand(0.25, 2)
      end
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

# Returns note length.
# Examples:
# l = 8 => Eight note
# l = 3 => Whole triplet
# l = 12 => Quarter triplet
define :note_length do |l|
  4.0 / l
end

# Plays an NES style arpeggio with a rate of 50 Hz.
# *notes* is an array and *length* is the length in beats
# for which the arpeggio should play.
# *synth* is an optional argument, defaults to :chiplead.
define :nes_arp do |notes, length, *args|
  in_thread do
    defaults = {
      synth: :chiplead
    }

    ag = args[0]
    ag = defaults if ag == nil
    ag = defaults.merge(ag)
    use_synth ag[:synth]

    rate = rt(1.0/50)
    beat_length = bt(length)
    nbr_notes = notes.length

    remain = beat_length
    while remain > rate
      play notes[tick%nbr_notes], duration: rate, release: 0, attack: 0
      remain -= rate
      sleep rate
    end
    play notes[tick%nbr_notes], duration: remain, release: 0, attack: 0
    sleep remain
  end
end

# Plays an NES style bass drum.
define :nes_bd do |*args|
  defaults = {
    amp: 1
  }

  ag = args[0]
  ag = defaults if ag == nil
  ag = defaults.merge(ag)

  use_synth :tri
  play :c3, slide: 0.05, release: 0.1, amp: ag[:amp]
  control note: :c1
end

# Plays a bass note preceded by a bass drum like kick to it.
define :nes_bd_bass do |n, *args|
  in_thread do
    defaults = {
      amp: 1,
      sustain: 0.5,
      attack: 0,
      release: 0.05,
      note_slide: 0.05
    }

    ag = args[0]
    ag = defaults if ag == nil
    ag = defaults.merge(ag)

    use_synth :chipbass
    s = play :c4, note_slide: ag[:note_slide], release: ag[:release], attack: ag[:attack], sustain: ag[:sustain]
    control s, note: n
  end
end

# Plays an NES style snare.
define :nes_sn do |*args|
  in_thread do
    defaults = {
      amp: 1
    }

    ag = args[0]
    ag = defaults if ag == nil
    ag = defaults.merge(ag)

    use_synth :fm
    use_synth_defaults divisor: 1.6666, attack: 0.0, depth: 1500, sustain: 0.06, release: 0.0, slide: 0.05

    s = play :c7, amp: ag[:amp]
    control s, note: :c6
  end
end

# Plays an NES style hi hat.
define :nes_hh do |*args|
  in_thread do
    defaults = {
      amp: 1
    }

    ag = args[0]
    ag = defaults if ag == nil
    ag = defaults.merge(ag)

    use_synth :cnoise
    use_synth_defaults attack: 0, sustain: 0, release: 0.05
    play :a, amp: ag[:amp]
  end
end

# A doppler effect style function.
# *note* is your f0 in midi form
# *speed* is the speed of the source in m/s
# *synth* is what synth you want to use
# *length* is the distance from which the source starts out in meters
define :doppler do |note, speed, synth, length|
  in_thread do
    defaults = {
      amp: 1,
      synth: :beep
    }

    ag = args[0]
    ag = defaults if ag == nil
    ag = defaults.merge(ag)

    f0 = midi_to_hz(note)
    fb = (1 + speed/343.0) * f0
    fa = (1 - speed/343.0) * f0

    sec = length / (speed * 1.0)

    s = synth ag[:synth], note: hz_to_midi(fb), pan_slide: sec * 2, pan: 1, attack: sec, release: sec, env_curve: 7, amp: ag[:amp]
    control s, pan: -1
    sleep sec - 0.095
    control s, note: hz_to_midi(fa), note_slide: 0.1
  end
end
