handlersCount = [2, 3];
Ma = [7, 10];
Ms = [10, 15];
predefinedHandlersCount = 2;
predefinedMa = 10;
predefinedMs = 10;

factorAnalysisResults = csvread('factorAnalysis.csv');

[x, y, z] = ndgrid(handlersCount, Ma, Ms);
plan = [x(:) y(:) z(:)]

coeffiecients = zeros(7, 8);
for parameter = 4:10
  A = zeros(length(plan));
  for i = 1:length(plan)
    x1 = plan(i, 1);
    x2 = plan(i, 2);
    x3 = plan(i, 3);
    A(i, :) = [1, x1, x2, x3, x1*x2, x1*x3, x2*x3, x1*x2*x3];
  end

  b = factorAnalysisResults(:, parameter);

  a = A^(-1)*b;

  coeffiecients(parameter - 3, :) = a';
end

csvwrite('regressionAnalysis.csv', coeffiecients);

p = regression(coeffiecients(1,:), predefinedHandlersCount, predefinedMa, predefinedMs)
Ns = regression(coeffiecients(2,:), predefinedHandlersCount, predefinedMa, predefinedMs)
Nq = regression(coeffiecients(3,:), predefinedHandlersCount, predefinedMa, predefinedMs)
Tq = regression(coeffiecients(4,:), predefinedHandlersCount, predefinedMa, predefinedMs)
Ts = regression(coeffiecients(5,:), predefinedHandlersCount, predefinedMa, predefinedMs)
Ca = regression(coeffiecients(6,:), predefinedHandlersCount, predefinedMa, predefinedMs)
Cr = regression(coeffiecients(7,:), predefinedHandlersCount, predefinedMa, predefinedMs)
