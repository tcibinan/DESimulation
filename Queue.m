classdef Queue < handle
   properties
      Size
      Capacity
   end
   methods
       function obj = Queue(capacity)
        obj.Capacity = capacity;
        obj.Size = 0;
      end
      function add(obj)
        if (obj.Size < obj.Capacity)
          obj.Size = obj.Size + 1;
        else
          error('Queue size overloading');
        end
      end
   end
end
