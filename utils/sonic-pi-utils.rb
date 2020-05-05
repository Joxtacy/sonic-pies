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
define :nes_bd do
  use_synth :tri
  play :c3, slide: 0.05, release: 0.1
  control note: :c1
end
