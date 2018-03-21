classdef State < handle

  properties
    n % transactions count
    Ms % transactions handling average delay
    Ma % transactions receiving average delay
    t = 0; % system current time
    ns = 0; % successfully handled transactions count
    Q = 0; % summary queued transactions delay
    P = 0; % summary transactions handling time
    A = [0.4, 1.2, 0.5, 1.7, 0.2]; % placeholder
    S = [2.0, 0.7, 0.2, 1.1, 3.7]; % placeholder
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
