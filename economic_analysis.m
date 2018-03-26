En = 0.15;
c1 = 4 * (10^6);
c2 = 8 * (10^4);
c3 = 5 * (10^3);
c4 = 0.02;
c5 = 0.095;
T = 2.5 * (10^7);

regressionAnalysis = csvread('regressionAnalysis.csv');

handlersCount = 2:0.1:3;
Ma = 7:0.5:10;
Ms = 10:0.5:15;

[x, y, z] = ndgrid(handlersCount, Ma, Ms);
plan = [x(:) y(:) z(:)];
length(plan)

result = zeros(length(plan), 11);
for i = 1:length(plan)
  s = plan(i, 1);
  localMa = plan(i, 2);
  localMs = plan(i, 3);
  p = regression(regressionAnalysis(1,:), s, localMa, localMs);
  Ns = regression(regressionAnalysis(2,:), s, localMa, localMs);
  Nq = regression(regressionAnalysis(3,:), s, localMa, localMs);
  Tq = regression(regressionAnalysis(4,:), s, localMa, localMs);
  Ts = regression(regressionAnalysis(5,:), s, localMa, localMs);
  Ca = regression(regressionAnalysis(6,:), s, localMa, localMs);
  Cr = regression(regressionAnalysis(7,:), s, localMa, localMs);
  I = economic(En, c1, c2, c3, c4, c5, T, s, localMa, Ns, Nq, Ca);

  result(i, :) = [s, localMa, localMs, p, Ns, Nq, Tq, Ts, Ca, Cr, I];
end

sortedResult = sortrows(result, 11);

csvwrite('economicAnalysis.csv', sortedResult);
