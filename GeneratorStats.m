classdef GeneratorStats < handle

  properties
    gen
    values
    expected
    variance
    precision = 0.5;
    narrowCoefficient = 3;
  end

  methods
      function obj = GeneratorStats(gen, n)
        obj.gen = gen.clone();

        obj.values = arrayfun(@(x) gen.next(), 1:n);
        obj.expected = sum(obj.values) / n;
        obj.variance = sum((obj.values - obj.expected) .^ 2) / (n - 1);
      end

      function nextPreviousScatter(obj)
        x = obj.values(1:(length(obj.values) - 1));
        y = obj.values(2:length(obj.values));

        scatter(x, y, 'filled');
        title('(Xi, Xi+1');
      end

      function distributionPlot(obj)
        x = 0:obj.precision:max(obj.values);
        y = arrayfun(@(x) sum(obj.values < x) / length(obj.values), x);

        plot(x, y);
        title('F(x)');
      end

      function densityHistogram(obj)
        x = 0:obj.precision:max(obj.values);
        F = arrayfun(@(x) sum(obj.values < x) / length(obj.values), x);

        narrowedLength = round(length(x) / obj.narrowCoefficient);
        narrowedX = linspace(0, max(obj.values), narrowedLength);
        narrowedY = hist(obj.values, narrowedLength) / length(obj.values);

        bar(narrowedX, narrowedY);
        title('f(x)');
      end

  end
end
