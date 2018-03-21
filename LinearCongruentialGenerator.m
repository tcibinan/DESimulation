classdef LinearCongruentialGenerator < handle

  properties
    m = 2^31 - 1;
    a = 630360016;
    ec
  end

  methods
    function obj = LinearCongruentialGenerator(ec1)
      obj.ec = ec1;
    end

    function num = next(obj)
      obj.ec = mod(obj.a * obj.ec, obj.m);
      num = obj.ec / obj.m;
    end
  end
end
