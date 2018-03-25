classdef ExponentialGenerator < handle

  properties
    lcg
    m
  end

  methods
    function obj = ExponentialGenerator(lcg, m)
      obj.lcg = lcg;
      obj.m = m;
    end

    function num = next(obj)
      num = -obj.m * log(obj.lcg.next());
    end

    function clone = clone(obj)
      clone = ExponentialGenerator(obj.lcg.clone(), obj.m);
    end

  end
end
