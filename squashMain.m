% squash(0,0,6.4, 9.75, 1, 20)
x0 = [1,-60];
A = [];
b = [];
x = fmincon(@squash, x0, A, b);