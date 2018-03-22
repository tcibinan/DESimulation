classdef PuassonGenerator < handle

  properties
    lcg
    m
  end

  methods
    function obj = PuassonGenerator(lcg, m)
      obj.lcg = lcg;
      obj.m = m;
    end

    function num = next(obj)
      num = -obj.m * log(obj.lcg.next());
    end

  end
end
