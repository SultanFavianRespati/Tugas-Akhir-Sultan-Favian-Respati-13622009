% function betaEdgeCrackNearHole


a = [0.00E+00
5.24E-04
1.05E-03
1.57E-03
2.10E-03
2.62E-03
3.14E-03
3.67E-03
4.19E-03
4.66E-03
];

beta = [2.24
2.25
2.265
2.285
2.31
2.35
2.42
2.52
2.675
3.105
];

betafactor = fit(a, beta, "poly6");

x = 0:5.24E-03/100:5.24E-03;
B = betafactor(x);
plot(x,B)