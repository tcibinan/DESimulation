% format short g

transactionsCount = 1000;
Ms = 10;
Ma = 10;
handlersCount = 2;
handlingQuant = 1;
queueSize = 34;

experiments = 50;
u = 1.96;
inits = randi(2147483647, experiments, 2);

for i = 1:length(inits)
  Agen = ExponentialGenerator(LinearCongruentialGenerator(inits(i, 1)), Ma);
  Sgen = ExponentialGenerator(LinearCongruentialGenerator(inits(i, 2)), Ms);
  model = Model(transactionsCount, Ms, Ma, handlersCount, handlingQuant, queueSize, Agen, Sgen);
  model.simulate();
  stats = model.stats();
  inits(i, 3) = stats.p;
  inits(i, 4) = stats.Ns;
  inits(i, 5) = stats.Nq;
  inits(i, 6) = stats.Tq;
  inits(i, 7) = stats.Ts;
  inits(i, 8) = stats.Ca;
  inits(i, 9) = stats.Cr;
end

for i = 3:9
  inits(experiments + 1, i) = sum(inits(1:experiments, i)) / experiments;
  inits(experiments + 2, i) = sum((inits(1:experiments, i) - inits(experiments + 1, i)) .^ 2) / (experiments - 1);
  inits(experiments + 3, i) = 0.05 * inits(experiments + 1, i);
  inits(experiments + 4, i) = u^2 * inits(experiments + 2, i) / (inits(experiments + 3, i) ^ 2);
end

csvwrite('first_launches.csv', inits);
