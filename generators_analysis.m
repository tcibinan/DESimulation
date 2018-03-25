transactionsCount = 1000;
Ms = 10;
Ma = 10;
Agen = ExponentialGenerator(LinearCongruentialGenerator(34238443), Ma);
Sgen = ExponentialGenerator(LinearCongruentialGenerator(432434), Ms);

AgenStats = GeneratorStats(Agen, transactionsCount);

% AgenStats.nextPreviousScatter();
% AgenStats.distributionPlot();
% AgenStats.densityHistogram();

SgenStats = GeneratorStats(Sgen, transactionsCount);

% SgenStats.nextPreviousScatter();
% SgenStats.distributionPlot();
% SgenStats.densityHistogram();
