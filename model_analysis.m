transactionsCount = 1000;
Ms = 10;
Ma = 10;
handlersCount = 2;
handlingQuant = 1;
queueSize = 34;
Agen = PuassonGenerator(LinearCongruentialGenerator(34238443), Ma);
Sgen = PuassonGenerator(LinearCongruentialGenerator(432434), Ms);

model = Model(transactionsCount, Ms, Ma, handlersCount, handlingQuant, queueSize, Agen, Sgen);

model.simulate();

model.stats()
