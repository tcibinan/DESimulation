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
    handlingQuant
    queue
  end

  methods
    function obj = Model(transactionsCount, Ms, Ma, handlersCount, handlingQuant, queueSize, Agen, Sgen)
      obj.n = transactionsCount;
      obj.Ms = Ms;
      obj.Ma = Ma;
      for i = 1:handlersCount
        obj.handlers(i).busy = false;
        obj.handlers(i).p = 0;
        obj.handlers(i).t = NaN;
        obj.handlers(i).cyclic = false;
      end
      obj.handlingQuant = handlingQuant;
      obj.queue = Queue(queueSize);

      obj.Agen = Agen;
      obj.A = arrayfun(@(x) obj.Agen.next(), 1:transactionsCount);
      obj.Aindex = 1;
      obj.tA = obj.A(obj.Aindex);

      obj.Sgen = Sgen;
    end

    function stats = stats(obj)
      stats.T = obj.t;
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
        prevT = obj.t;
        isNewTransaction = false;
        [closestHandlerIndex, closestHandlerTime] = obj.findClosestHandler();

        if (isnan(closestHandlerTime))
          if (~isnan(obj.tA))
            obj.retrieveNextTransactionTime();
            if (~obj.queue.isFull())
              obj.queue.push();
              isNewTransaction = true;
            end
          else
            disp('Simulation has finished');
            break
          end
        else
          if (~isnan(obj.tA))
            if (obj.tA < closestHandlerTime)
              obj.retrieveNextTransactionTime();
              if (~obj.queue.isFull())
                obj.queue.push();
                isNewTransaction = true;
              end
            else
              obj.t = closestHandlerTime;
              isNewTransaction = obj.freeHandler(closestHandlerIndex);
            end
          else
            obj.t = closestHandlerTime;
            isNewTransaction = obj.freeHandler(closestHandlerIndex);
          end
        end

        % update handling times
        for index = 1:length(obj.handlers)
          if (obj.handlers(index).busy)
            obj.handlers(index).p += obj.t - prevT;
          end
        end

        % update queue waiting time
        if (~isNewTransaction)
          obj.queue.d += obj.queue.size * (obj.t - prevT);
        else
          obj.queue.d += (obj.queue.size - 1) * (obj.t - prevT);
        end

        if (obj.queue.size > 0)
          freeHandlersIndexes = obj.findFreeHandlers();
          transactionsToBeHandled = min(obj.queue.size, length(freeHandlersIndexes));
          for index = 1:transactionsToBeHandled
            obj.queue.pop();
            obj.handlers(freeHandlersIndexes(index)).busy = true;
            handlingPeriod = obj.Sgen.next();
            if (handlingPeriod < obj.handlingQuant)
              obj.handlers(freeHandlersIndexes(index)).t = obj.t + handlingPeriod;
              obj.handlers(freeHandlersIndexes(index)).cyclic = false;
            else
              obj.handlers(freeHandlersIndexes(index)).t = obj.t + obj.handlingQuant;
              obj.handlers(freeHandlersIndexes(index)).cyclic = true;
            end
          end
        end

        % disp(['t = ', num2str(obj.t)]);
        % disp(['queue = ', num2str(obj.queue.size]);
        % disp(['handlers = ', num2str([obj.handlers.busy])]);
        % disp('-----------');
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

    function isReturnedToQueue = freeHandler(obj, index)
      isReturnedToQueue = false;
      if (obj.handlers(index).cyclic)
        if (~obj.queue.isFull())
          obj.queue.push();
          isReturnedToQueue = true;
        end
      else
        obj.ns += 1;
      end
      obj.handlers(index).busy = false;
      obj.handlers(index).t = NaN;
      obj.handlers(index).cyclic = false;
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

    function [handlersIndexes] = findFreeHandlers(obj)
      handlersIndexes = [];
      for i = 1:length(obj.handlers)
        if (~obj.handlers(i).busy)
          handlersIndexes = [handlersIndexes i];
        end
      end
    end

  end
end
