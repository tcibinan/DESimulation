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
    function add(obj)
      if (obj.size < obj.capacity)
        obj.size = obj.size + 1;
      else
        error('Queue size overloading');
      end
    end
  end
end
