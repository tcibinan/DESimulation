classdef Queue < handle

  properties
    d = 0;
    transactions = [];
    capacity
  end

  methods
    function obj = Queue(capacity)
      obj.capacity = capacity;
    end

    function push(obj, transaction)
      if (obj.size() < obj.capacity)
        obj.transactions = [obj.transactions transaction];
      else
        error('Queue size is greater than the capacity');
      end
    end

    function size = size(obj)
      size = length(obj.transactions);
    end

    function transaction = pop(obj)
      if (obj.size() > 0)
        transaction = obj.transactions(1);
        obj.transactions = obj.transactions(2:length(obj.transactions));
      else
        error('Queue size is lower than 0');
      end
    end

    function isFull = isFull(obj)
      isFull = obj.size() == obj.capacity;
    end

  end
end
