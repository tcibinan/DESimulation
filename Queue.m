classdef Queue < handle

  properties
    d = 0;
    size = 0;
    capacity
  end

  methods
    function obj = Queue(capacity)
      obj.capacity = capacity;
    end

    function push(obj)
      if (obj.size < obj.capacity)
        obj.size = obj.size + 1;
      else
        error('Queue size is greater than the capacity');
      end
    end

    function pop(obj)
      if (obj.size > 0)
        obj.size = obj.size - 1;
      else
        error('Queue size is lower than 0');
      end
    end

    function isFull = isFull(obj)
      isFull = obj.size == obj.capacity;
    end

  end
end
