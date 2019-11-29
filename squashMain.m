% squash([5 18]);
x0 = [5,0];
params = [0,0];
lb = [0, -18.17]; % 0 <= theta_v <= 25.11
ub = [25.11, 18.17]; % -18.17 <= theta_h <= 18.17
A = [];
b = [];
c = [];
d = [];
[x] = fmincon(@(params)squash(params), x0, A, b, c, d, lb ,ub);

disp("theta_v: ");
disp(x(1));
disp("theta_h: ");
disp(x(2));