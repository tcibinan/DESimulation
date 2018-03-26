s = 2;
Ma = 10;
Ms = 10;
ds = 0.01;

regressionAnalysis = csvread('regressionAnalysis.csv');

inits = [
s, Ma, Ms;
s+ds, Ma, Ms;
s-ds, Ma, Ms;
s, Ma+ds, Ms;
s, Ma-ds, Ms;
s, Ma, Ms+ds;
s, Ma, Ms-ds
]

for i = 1:length(inits)
  localS = inits(i, 1);
  localMa = inits(i, 2);
  localMs = inits(i, 3);

  p = regression(regressionAnalysis(1,:), localS, localMa, localMs);
  Ns = regression(regressionAnalysis(2,:), localS, localMa, localMs);
  Nq = regression(regressionAnalysis(3,:), localS, localMa, localMs);
  Tq = regression(regressionAnalysis(4,:), localS, localMa, localMs);
  Ts = regression(regressionAnalysis(5,:), localS, localMa, localMs);
  Ca = regression(regressionAnalysis(6,:), localS, localMa, localMs);
  Cr = regression(regressionAnalysis(7,:), localS, localMa, localMs);

  inits(i, 4:10) = [p, Ns, Nq, Tq, Ts, Ca, Cr];
end

csvwrite('regressionValidations.csv', inits);
