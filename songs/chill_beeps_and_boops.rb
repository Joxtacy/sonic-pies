# Chill Beeps and Boops - created by Joxtacy

use_random_seed 69

live_loop :beat do
  puts "beat"
  sleep 1
end

live_loop :bar do
  puts "bar"
  sleep 4
end

live_loop :blips, sync: :bar do
  with_fx :reverb, mix: 0.6, room: 1 do |rev|
    remaining = 4
    while remaining > 0
      #play (scale :c, :major).choose, amp: rand, pan: rrand(-1, 1)
      s = [0.25, 0.5, 0.75].choose
      if remaining < s then
        s = remaining
      end
      remaining -= s
      sleep s
    end
  end
end

live_loop :drums, sync: :bar do
  with_fx :reverb do |rev|
    control rev, room: 0.6, damp: 0.5
    #sample :drum_bass_hard, amp: 1
    sleep 2
    control rev, room: 1, damp: 0.1
    #sample :sn_zome
    sleep 2
  end
end

live_loop :hh, sync: :bar do
  hits = 4
  b = 4.0/hits
  hits.times do
    #sample :drum_cymbal_closed, amp: rrand(0.5, 0.7)
    sleep b
  end
end

live_loop :bass, sync: :bar do
  with_fx :slicer do |sl|
    with_fx :lpf, cutoff_slide: 2 do |hp|
      use_synth :chipbass
      control hp, cutoff: (ring 60, 130).tick
      control sl, phase: 0.25, wave: 1
      #play [:c2, :e2, :a2].choose, release: 2.5
      sleep 2
    end
  end
end
