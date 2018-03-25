transactionsCount = 1000;
Ms = 10;
Ma = 10;
handlersCount = 2;
handlingQuant = 1;
queueSize = 34;
Agen = ExponentialGenerator(LinearCongruentialGenerator(1119234), Ma);
Sgen = ExponentialGenerator(LinearCongruentialGenerator(4324113), Ms);

AgenStats = GeneratorStats(Agen.clone(), 10000);
disp('Генератор времени поступления требований:');
M = AgenStats.expected
D = AgenStats.variance
interval = AgenStats.confidenceInterval(1.96)
Z = AgenStats.Z(Ma)
[Z, X2] = AgenStats.X2(@(x) (1/Ma)*exp(-(1/Ma)*x), 0.05)
%genStats.densityHistogram();
%genStats.nextPreviousScatter();
%genStats.correlationCoefficientPlot(20);

SgenStats = GeneratorStats(Sgen.clone(), 10000);
disp('Генератор времени обработки требований:');
M = SgenStats.expected
D = SgenStats.variance
interval = SgenStats.confidenceInterval(1.96)
Z = SgenStats.Z(Ma)
[Z, X2] = SgenStats.X2(@(x) (1/Ma)*exp(-(1/Ma)*x), 0.05)
%genStats1.densityHistogram();
%genStats1.nextPreviousScatter();
%genStats1.correlationCoefficientPlot(20);

%model = Model(transactionsCount, Ms, Ma, handlersCount, handlingQuant, queueSize, Agen, Sgen);

%model.simulate();

%figure();
%model.averageQueueSizePlot();

% figure();
% model.transactionsInModelPlot();
