# Chill Beeps and Boops - created by Joxtacy

use_random_seed 69
with_fx :reverb, mix: 0.6, room: 1 do
  loop do
    play (scale :c, :major).choose, amp: rand, pan: rrand(-1, 1)
    sleep [0.25, 0.5, 0.75].choose
  end
end
