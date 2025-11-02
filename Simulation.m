clc;
close all;

% --- Check if required simulation outputs exist ---
required_vars = {'x_host', 'x_lead', 'v_host', 'v_lead', 'Drel', 'Dsec'};
for v = required_vars
    if ~exist('out', 'var') || ~isprop(out, v{1})
        error(['Simulation output missing variable: ', v{1}]);
    end
end

% --- Extract position and velocity data ---
x_host_values = out.x_host.signals.values;
x_lead_values = out.x_lead.signals.values;
v_host_values = out.v_host.signals.values;
v_lead_values = out.v_lead.signals.values;
Drel_values = out.Drel.signals.values;
Dsec_values = out.Dsec.signals.values;

time = out.x_host.time;

% --- Ensure all vectors have the same length ---
N = min([length(x_host_values), length(x_lead_values), length(v_host_values), length(v_lead_values), length(Drel_values), length(Dsec_values), length(time)]);
x_host_values = x_host_values(1:N);
x_lead_values = x_lead_values(1:N);
v_host_values = v_host_values(1:N);
v_lead_values = v_lead_values(1:N);
Drel_values = Drel_values(1:N);
Dsec_values = Dsec_values(1:N);
time = time(1:N);

% --- Vehicle and environment setup ---
y_host = zeros(N,1);
y_lead = zeros(N,1);

vehicle_width = 4.6;
vehicle_height = 1.2;

% --- Plot setup ---
figure(1);
clf;
set(gcf, 'WindowState', 'maximized');
hold on;
grid on;
xlabel('X Position (m)');
ylabel('Y Position (m)');
ylim([-20 20]);

% Draw lane lines
yline(1.85, 'k--', 'LineWidth', 1.5);
yline(-1.85, 'k--', 'LineWidth', 1.5);

% Pre-allocate text handles for velocity and distance info
txt_v_lead = text(0, 15, '', 'FontSize', 12, 'Color', 'r', 'FontWeight', 'bold');
txt_v_host = text(0, 13, '', 'FontSize', 12, 'Color', 'g', 'FontWeight', 'bold');
txt_d_rel = text(0, 11, '', 'FontSize', 12, 'Color', 'b', 'FontWeight', 'bold');
txt_d_sec = text(0, 9, '', 'FontSize', 12, 'Color', 'm', 'FontWeight', 'bold');


% --- Animation Loop ---
for ii = 1:N
    % Draw vehicles as filled rectangles
    rect_host = rectangle('Position', [x_host_values(ii) - vehicle_width/2, y_host(ii) - vehicle_height/2, vehicle_width, vehicle_height], ...
                          'FaceColor', 'r', 'EdgeColor', 'k', 'LineWidth', 1.5);
    rect_lead = rectangle('Position', [x_lead_values(ii) - vehicle_width/2, y_lead(ii) - vehicle_height/2, vehicle_width, vehicle_height], ...
                          'FaceColor', 'g', 'EdgeColor', 'k', 'LineWidth', 1.5);

    % Update text positions relative to host vehicle position
    base_x_text = x_host_values(ii) - 30; % Shift text to the left of host car
    
    % Update velocity and distance texts
    set(txt_v_lead, 'Position', [base_x_text, 15], 'String', sprintf('Vitesse du véhicule suiveur : %.2f km/h', v_lead_values(ii)));
    set(txt_v_host, 'Position', [base_x_text, 13], 'String', sprintf('Vitesse du véhicule leader : %.2f km/h', v_host_values(ii)));
    set(txt_d_rel, 'Position', [base_x_text, 11], 'String', sprintf('Distance relative : %.2f m', Drel_values(ii)));
    set(txt_d_sec, 'Position', [base_x_text, 9], 'String', sprintf('Distance de sécurité : %.2f m', Dsec_values(ii)));

    % Set axis limits zoomed out as before
    axis([x_host_values(ii) - 40, x_host_values(ii) + 140, -20, 20]);

    % Update title
    title(sprintf('Animation du scénario | Temps = %.2f s', time(ii)));

    drawnow;

    % Delete vehicle rectangles for next frame
    if ishandle(rect_host), delete(rect_host); end
    if ishandle(rect_lead), delete(rect_lead); end
end



hold off;
