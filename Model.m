classdef Model < handle

  properties
    n % transactions count
    Ms % transactions handling average delay
    Ma % transactions receiving average delay
    t = 0; % system current time
    ns = 0; % successfully handled transactions count
    Q = 0; % summary queued transactions delay
    P = 0; % summary transactions handling time
    Agen
    A
    Aindex
    tA
    Sgen
    handlers
    queue
  end

  methods
    function obj = Model(transactionsCount, Ms, Ma, handlersCount, queueSize)
      obj.n = transactionsCount;
      obj.Ms = Ms;
      obj.Ma = Ma;
      for i = 1:handlersCount
        obj.handlers(i).busy = false;
        obj.handlers(i).p = 1;
        obj.handlers(i).t = NaN;
      end
      obj.queue = Queue(queueSize);

      obj.Agen = PuassonGenerator(LinearCongruentialGenerator(34238443), obj.Ma);
      obj.A = arrayfun(@(x) obj.Agen.next(), 1:transactionsCount);
      obj.Aindex = 1;
      obj.tA = obj.A(obj.Aindex);

      obj.Sgen = PuassonGenerator(LinearCongruentialGenerator(432434), obj.Ms);
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

    function simulate(obj)
      disp('Simulation has been started');

      while (true)
        [closestHandlerIndex, closestHandlerTime] = obj.findClosestHandler();

        if (isnan(closestHandlerTime))
          if (~isnan(obj.tA))
            obj.retrieveNextTransactionTime();
            obj.appendTransactionToHandling();
          else
            disp('Simulation has finished');
            break
          end
        else
          if (~isnan(obj.tA))
            if (obj.tA < closestHandlerTime)
              obj.retrieveNextTransactionTime();
              obj.appendTransactionToHandling();
            else
              obj.t = closestHandlerTime;
              obj.freeHandler(closestHandlerIndex);
            end
          else
            obj.t = closestHandlerTime;
            obj.freeHandler(closestHandlerIndex);
          end
        end
      end
    end

    function retrieveNextTransactionTime(obj)
      obj.t = obj.tA;
      obj.Aindex += 1;
      if (obj.Aindex <= obj.n)
        obj.tA += obj.A(obj.Aindex);
      else
        obj.tA = NaN;
      end
    end

    function freeHandler(obj, index)
      obj.handlers(index).busy = false;
      obj.handlers(index).t = NaN;
    end

    function index = findFreeHandlerIndex(obj)
      index = NaN;
      for i = 1:length(obj.handlers)
        if (~obj.handlers(i).busy)
          index = i;
          break
        end
      end
    end

    function [closestHandlerIndex, closestHandlerTime] = findClosestHandler(obj)
      closestHandlerIndex = NaN;
      closestHandlerTime = NaN;
      for i = 1:length(obj.handlers)
        if (isnan(closestHandlerTime) || closestHandlerTime > obj.handlers(i).t)
          closestHandlerIndex = i;
          closestHandlerTime = obj.handlers(i).t;
        end
      end
    end

    function appendTransactionToHandling(obj)
      freeHandlerIndex = obj.findFreeHandlerIndex();
      if (~isnan(freeHandlerIndex))
        obj.handlers(freeHandlerIndex).busy = true;
        obj.handlers(freeHandlerIndex).t = obj.Sgen.next();
      else
        % todo: Add to queue
        disp('Temporary throw transaction to the trash instead of a queue');
      end
    end

  end
end
