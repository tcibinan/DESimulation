classdef Queue < handle

  properties
    d = 0;
    size
    capacity
  end

  methods
    function obj = Queue(capacity)
      obj.capacity = capacity;
      obj.size = 0;
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

  end
end
