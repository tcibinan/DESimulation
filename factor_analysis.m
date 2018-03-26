experimentsPerFactorDot = 112;

transactionsCount = 1000;
queueSize = 34;
handlingQuant = 1;

handlersCount = [2, 3];
Ma = [7, 10];
Ms = [10, 15];

[x, y, z] = ndgrid(handlersCount, Ma, Ms);
plan = [x(:) y(:) z(:)]

for factorDot = 1:length(plan)
  factorDotExperiments = randi(2147483647, experimentsPerFactorDot, 2);

  for i = 1:length(factorDotExperiments)
    localHandlersCount = plan(factorDot, 1);
    localMa = plan(factorDot, 2);
    localMs = plan(factorDot, 3);
    Agen = ExponentialGenerator(LinearCongruentialGenerator(factorDotExperiments(i, 1)), localMa);
    Sgen = ExponentialGenerator(LinearCongruentialGenerator(factorDotExperiments(i, 2)), localMs);
    model = Model(transactionsCount, localMs, localMa, localHandlersCount, handlingQuant, queueSize, Agen, Sgen);
    model.simulate();
    stats = model.stats();
    factorDotExperiments(i, 3) = stats.p;
    factorDotExperiments(i, 4) = stats.Ns;
    factorDotExperiments(i, 5) = stats.Nq;
    factorDotExperiments(i, 6) = stats.Tq;
    factorDotExperiments(i, 7) = stats.Ts;
    factorDotExperiments(i, 8) = stats.Ca;
    factorDotExperiments(i, 9) = stats.Cr;
  end

  csvwrite(['factorDot', num2str(factorDot), 'Experiments.csv'], factorDotExperiments);

  plan(factorDot, 4:10) = mean(factorDotExperiments(:, 3:9));
end

csvwrite('factorAnalysis.csv', plan);
