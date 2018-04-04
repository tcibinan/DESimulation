En = 0.15;
c1 = 4 * (10^6);
c2 = 8 * (10^4);
c3 = 5 * (10^3);
c4 = 0.02;
c5 = 0.095;
T = 2.5 * (10^7);

regressionAnalysis = csvread('regressionAnalysis.csv');

% handlersCount = 1:0.5:3;
% Ma = 5:0.4:15;
% Ms = 5:0.4:15;
handlersCount = 1:0.4:4;
Ma = 3:0.5:17;
Ms = 5:0.3:10;

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

filteredResults = zeros(1, 11);
j = 0;
for i = 1:length(result)
  if (sum(result(i, :) < 0) == 0)
    j++;
    filteredResults(j,:) = result(i,:);
  end
end
length(filteredResults)

sortedByIncreasingI = sortrows(filteredResults, 11);

% empirical sortings
sortedByDecreasingP = sortrows(filteredResults, -4);
sortedByOptimal = sortedByIncreasingI;
for i = 1:length(sortedByIncreasingI)
  for j = 1:length(sortedByDecreasingP)
    if (sortedByDecreasingP(j,1:3) == sortedByIncreasingI(i,1:3))
      break;
    end
  end
  sortedByOptimal(i, 12) = i;
  sortedByOptimal(i, 13) = j;
  sortedByOptimal(i, 14) = abs(i-j);
  if j > 80
    sortedByOptimal(i, 13) = 0;
    sortedByOptimal(i, 14) = 0;
  end
end

csvwrite('economicAnalysis.csv', sortedByIncreasingI);
csvwrite('economicAnalysis1.csv', sortedByDecreasingP);
csvwrite('economicAnalysis2.csv', sortrows(sortedByOptimal, 14));
