parametersCount = 7;

factorAnalysisResults = csvread('factorAnalysis.csv');

[x, y, z] = ndgrid([-1 1], [-1 1], [-1 1]);
plan = [x(:) y(:) z(:)]
result = zeros(parametersCount, 2^3-1);

for i = 1:parametersCount
  e1 = sum(plan(:, 1) .* factorAnalysisResults(:, i + 3))/3;
  e2 = sum(plan(:, 2) .* factorAnalysisResults(:, i + 3))/3;
  e3 = sum(plan(:, 3) .* factorAnalysisResults(:, i + 3))/3;
  e12 = sum(plan(:, 1) .* plan(:, 2) .* factorAnalysisResults(:, i + 3))/3;
  e13 = sum(plan(:, 1) .* plan(:, 3) .* factorAnalysisResults(:, i + 3))/3;
  e23 = sum(plan(:, 2) .* plan(:, 3) .* factorAnalysisResults(:, i + 3))/3;
  e123 = sum(plan(:, 1) .* plan(:, 2) .* plan(:, 3) .* factorAnalysisResults(:, i + 3))/3;

  result(i, :) = [e1, e2, e3, e12, e13, e23, e123];
end

csvwrite('effectsAnalysis.csv', result);
