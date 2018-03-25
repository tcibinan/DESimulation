classdef GeneratorStats < handle

  properties
    gen
    values
    expected
    variance
    precision = 0.5;
    narrowCoefficient = 3;
    k;
  end

  methods
      function obj = GeneratorStats(gen, n)
        obj.gen = gen.clone();

        obj.values = arrayfun(@(x) gen.next(), 1:n);
        obj.expected = sum(obj.values) / n;
        obj.variance = sum((obj.values - obj.expected) .^ 2) / (n - 1);
        obj.k = floor(1 + 3.3*log(n));
      end

      function interval = confidenceInterval(obj, u)
        delta = u*sqrt(obj.precision/length(obj.values));
        interval = [obj.expected - delta, obj.expected + delta];
      end

      function Z = Z(obj, m)
        Z = sqrt(length(obj.values))*(obj.expected - m)/sqrt(obj.variance);
      end

      function [Z, X2] = X2(obj, func, a)
        p = zeros(1, obj.k);
        h = zeros(1, obj.k);

        % intervals with equal length (gives bad results in current conditions)
        %
        % delta = (max(obj.values)-min(obj.values))/obj.k;
        % from = min(obj.values);
        % to = from + delta;
        % for i = 1:obj.k
        %   p(i) = quad(func, from, to);
        %   h(i) = sum((obj.values > from) == (obj.values < to));
        %   from = from + delta;
        %   to = to + delta;
        % end

        % intervals with equal h

        number = floor(length(obj.values) / obj.k);
        sortedValues = sort(obj.values);
        h(:) = number;

        currentNumber = 0;
        currentBunch = 1;
        for i = 1:length(sortedValues)
          if currentNumber < number
            currentNumber += 1;
          else
            p(currentBunch) = quad(func, sortedValues(i - number), sortedValues(i - 1));
            currentNumber = 0;
            currentBunch += 1;
          end
        end
        p(obj.k) = quad(func, sortedValues((currentBunch-1)*number), sortedValues(length(sortedValues)));
        h(obj.k) += length(obj.values) - sum(h);

        X2 = chi2inv(1-a, obj.k-1);
        Z = 0;
        for i = 1:obj.k
          a = ((h(i) - length(obj.values)*p(i))^2);
          b = (length(obj.values)*p(i));
          y = a / b
          Z += y;
        end
      end

      function nextPreviousScatter(obj)
        x = obj.values(1:(length(obj.values) - 1));
        y = obj.values(2:length(obj.values));

        scatter(x, y, 'filled');
        title('Зависимость следующего от предыдущего');
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

      function correlationCoefficientPlot(obj, kSize)
        k = zeros(1, length(obj.values));
        for j = 1:(length(obj.values)-1)
          for i = 1:(length(obj.values) - j)
            k(i) += (obj.values(i) - obj.expected) * (obj.values(i+j) - obj.expected);
          end
          k(i) /= length(obj.values) - j;
          k(i) /= obj.variance^2;
        end
        scatter(1:kSize, k(1:kSize), 'filled');
        title('Коэффициент корелляции');
      end

  end
end
