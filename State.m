classdef State < handle

  properties
    n % transactions count
    Ms % transactions handling average delay
    Ma % transactions receiving average delay
    t = 0; % system current time
    ns = 0; % successfully handled transactions count
    Q = 0; % summary queued transactions delay
    P = 0; % summary transactions handling time
    Agen
    Sgen
    A
    S
    handlers
    queue
  end

  methods
    function obj = State(transactionsCount, Ms, Ma, handlersCount, queueSize)
      obj.n = transactionsCount;
      obj.Ms = Ms;
      obj.Ma = Ma;
      for i = 1:handlersCount
        obj.handlers(i).busy = false;
        obj.handlers(i).p = 1;
      end
      obj.queue = Queue(queueSize);

      obj.Agen = PuassonGenerator(LinearCongruentialGenerator(34238443), 10);
      obj.Sgen = PuassonGenerator(LinearCongruentialGenerator(432434), 10);
      obj.A = arrayfun(@(x) obj.Agen.next(), 1:transactionsCount);
      obj.S = arrayfun(@(x) obj.Sgen.next(), 1:transactionsCount);
    end

    function stats = stats(obj)
      stats.T = sum(obj.A);
      stats.q = obj.queue.d / stats.T;
      stats.p = 1 / length(obj.handlers) * sum([obj.handlers.p] ./ stats.T);
      stats.Tq = obj.queue.d / obj.n;
      stats.Ts = stats.Tq + obj.Ms;
      stats.Nq = stats.Tq / obj.Ma;
      stats.Ns = stats.Ts / obj.Ma;
      stats.Ca = obj.ns / stats.T;
      stats.Cr = obj.ns / obj.n;
    end
  end
end
