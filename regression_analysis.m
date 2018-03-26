handlersCount = [2, 3];
Ma = [7, 10];
Ms = [10, 15];

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
