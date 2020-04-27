# Chips and Dip - created by Joxtacy

live_loop :beat do
  tick
  #puts "beat #{look}"
  sample :perc_snap if look < 4
  sleep 1
end

live_loop :bar do
  puts "bar #{tick}"
  sleep 4
end

define :sleep_calc do |remain, attempt|
  if remain < attempt then
    return remain
  else
    return attempt
  end
end

live_loop :bass, sync: :bar do
  use_synth :square
  remaining = 4
  while remaining > 0
    play (scale :a1, :minor_pentatonic, 2).choose, amp: rrand(0.5, 0.7), attack: 0.01, release: rrand(0.15, 0.25), cutoff: rrand(70, 130)
    sleep_time = [0.125, 0.25, 0.5].choose
    #puts "s1: #{sleep_time}"
    sleep_time = sleep_calc(remaining, sleep_time)
    #puts "s2: #{sleep_time}"
    remaining = remaining - sleep_time
    #puts "remaining: #{remaining}"
    sleep sleep_time
  end
end

with_fx :reverb, room: 0.8 do |r|
  live_loop :bd, sync: :bar do
    sample :bd_tek
    sleep 1
    sample :sn_dolf, rate: (knit 1, 4, -1, 1).choose
    sleep 1
  end
end

live_loop :hh, sync: :bar do
  use_synth :noise
  hits = 8
  b = 4.0/hits
  hits.times do
    play :c4, release: 0.025, amp: rrand(0.5, 0.8)
    sleep b
  end
end

with_fx :reverb, room: 0.8, mix: 0.8 do |r|
  live_loop :chords, sync: :bar do
    use_synth :chiplead
    chords = (ring (chord :c4, :M7), (chord :e4, :minor7), (chord :a3, :minor7), (chord :g3, :M7))
    play chords.choose, attack: 0, release: 2.5
    sleep 2
  end
end

