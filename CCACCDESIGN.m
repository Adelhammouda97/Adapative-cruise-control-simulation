
%% Cruise Control design for Vehicle model longitudinal dynamics

m = 1084;               % mass of vehicle in Kg.
g = 9.81;               % acceleration due to gravity in mpss
Cd = 0.3;               % drag coefficient
f = 0.0125;             % Rolling coefficient
V0 = 27.80;             % Initial velocity of the car in m/s
Vw_0 = 1.2;             % Initial wind velocity in m/s
A = 2.24;               % Cross sectional Area of the tyre surface
rho = 1.2;              % pressure in Km/m^3

sim_time = 300;

%% Modele du vehicule
plant_num = 1;
plant_den = [1084 17];
G_plant = tf(plant_num, plant_den);

% %% PID Gain Values from PID Tuner App
 Kp = 174.6119;
 Ki = 10.1187;
 Kd = 0;

% %% Script to demand set speed value from user
prompt_user = {'Selectionner la vitesse desirée Km/h'};
dlgtitle = 'Input';
dims = 1;
definput = {'0'};
answer = cell2mat(inputdlg(prompt_user, dlgtitle, dims, definput));
V_set_speed = str2double(answer);


% time = simout.tout;
% x_host = simout.x_host.Data;  % Direct access to your timeseries
% x_lead = simout.x_lead.Data;
% figure;
% plot(time, x_host, 'b', time, x_lead, 'r');
% legend('Host', 'Lead');
%% Plotting the output of various section
% figure
% plot(out.V_set_speed_mps.time, out.V_set_speed_mps.data, 'Linewidth', 2)
% hold all; grid on; xlabel('Time(sec)'); ylabel('Velocity(mps)');
% plot(out.Velocity_kph.time, out.Velocity_kph.data, 'Linewidth', 2)
% plot(out.Velocity_mps.time, out.Velocity_mps.data, 'Linewidth', 2)

% m = 1084;   %mass
% b = 17;     %damping coefficient
% u = 475.72; %nominal force
% r = 27.78;  %desired speed
% 
% Gs = tf(1, [m, b]); % s-domain
% 
% Ts = 1;             % sampling time
% Gz = c2d(Gs, Ts);   % z-domain
% 
% % analysis of step response
% figure(1)
% step(u*Gs)
% 
% % Open-loop poles/zeros
% figure(2)
% pzmap(Gz)
% axis([-1 1 -1 1])
% 
% % Open-loop Bode plot
% figure(3)
% bode(Gz)