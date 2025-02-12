function [final_depth, ticks] = simulate_minecraft_sink(fall_height, max_ticks)
if nargin < 2, max_ticks = 200; end
g_air = 0.04;
terminal_velocity = 3.92;
v = sqrt(2 * g_air * fall_height);
if v > terminal_velocity, v = terminal_velocity; end
tick = 0;
depth = 0;
dt = 0.05;
water_acceleration = 0.02;
drag_factor = 0.8;
while tick < max_ticks
    v = (v + water_acceleration) * drag_factor;
    depth = depth + v;
    tick = tick + 1;
    if v < 0.001, break; end
end
final_depth = depth;
end
