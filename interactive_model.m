global model;

windowX = 1100;
windowY = 500;
plotsPosition = [0.05 0.45 0.55 0.35];
fontSize = 8;
headersFontSize = 10;
numbersFontSize = 10;
status.waiting = 'Статус: Ожидание.';
status.modelling = 'Статус: Моделирование в процессе...';
status.error = 'Статус: Моделирование завершено с ошибкой.';
status.finished = 'Статус: Моделирование завершено.';

defaults.transactionsCount = '1000';
defaults.Ma = '10';
defaults.Ms = '10';
defaults.handlersCount = '2';
defaults.queueSize = '34';
defaults.AgenInit = '1119234';
defaults.SgenInit = '4324113';
defaults.handlingQuant = '1';

function text = text(string, position, fontSize)
  text = uicontrol(
    'Style', 'text',
    'String', string,
    'Units', 'normalized',
    'Position', position,
    'FontSize', fontSize
  );
end

function input = input(defaultValue, position)
  input = uicontrol(
    'Style', 'edit',
    'String', defaultValue,
    'Units', 'normalized',
    'Position', position
  );
end

function btn = btn(string, position, callback, fontSize)
  if (nargin < 4)
    btn = uicontrol(
      'Style', 'pushbutton',
      'String', string,
      'Units', 'normalized',
      'Position', position,
      'Callback', callback
    );
  else
    btn = uicontrol(
      'Style', 'pushbutton',
      'String', string,
      'Units', 'normalized',
      'Position', position,
      'Callback', callback,
      'FontSize', fontSize
    );
  end
end

function startModulation(source, eventdata, forms, status)
  transactionsCount = str2num(get(forms.transactionsCountInput, 'String'));
  Ma = str2num(get(forms.MaInput , 'String'));
  Ms = str2num(get(forms.MsInput , 'String'));
  handlersCount = str2num(get(forms.handlersCountInput , 'String'));
  handlingQuant = str2num(get(forms.handlingQuantInput , 'String'));
  queueSize = str2num(get(forms.queueSizeInput , 'String'));
  Agen = ExponentialGenerator(
    LinearCongruentialGenerator(str2num(get(forms.AgenInitInput, 'String'))),
    Ma
  );
  Sgen = ExponentialGenerator(
    LinearCongruentialGenerator(str2num(get(forms.SgenInitInput, 'String'))),
    Ms
  );

  global model;
  model = Model(transactionsCount, Ms, Ma, handlersCount, handlingQuant, queueSize, Agen, Sgen);

  set(forms.statusText, 'String', status.modelling);
  try
    model.simulate();
  catch e
    set(forms.statusText, 'String', status.error);
    rethrow(e);
  end
  set(forms.statusText, 'String', status.finished);

  stats = model.stats();
  set(forms.TValue, 'String', num2str(stats.T));
  set(forms.CaValue, 'String', num2str(stats.Ca));
  set(forms.CrValue, 'String', num2str(stats.Cr));
  set(forms.pValue, 'String', num2str(stats.p));
  set(forms.TqValue, 'String', num2str(stats.Tq));
  set(forms.TsValue, 'String', num2str(stats.Ts));
  set(forms.NqValue, 'String', num2str(stats.Nq));
  set(forms.NsValue, 'String', num2str(stats.Ns));

end

function show()
  disp('Graphic is not implemented yet');
end

function genStats = retrieveAgenStats(forms)
  transactionsCount = str2num(get(forms.transactionsCountInput, 'String'));
  Ma = str2num(get(forms.MaInput , 'String'));
  Agen = ExponentialGenerator(
    LinearCongruentialGenerator(str2num(get(forms.AgenInitInput, 'String'))),
    Ma
  );

  genStats = GeneratorStats(Agen, transactionsCount);
end

function showAgenDistributionPlot(source, eventdata, forms, position)
  subplot('Position', position);
  retrieveAgenStats(forms).distributionPlot(position);
end

function showAgenDensityHistogram(source, eventdata, forms, position)
  subplot('Position', position);
  retrieveAgenStats(forms).densityHistogram(position);
end

function genStats = retrieveSgenStats(forms)
  transactionsCount = str2num(get(forms.transactionsCountInput, 'String'));
  Ms = str2num(get(forms.MsInput , 'String'));
  Sgen = ExponentialGenerator(
    LinearCongruentialGenerator(str2num(get(forms.SgenInitInput, 'String'))),
    Ms
  );

  genStats = GeneratorStats(Sgen, transactionsCount);
end

function showSgenDistributionPlot(source, eventdata, forms, position)
  subplot('Position', position);
  retrieveSgenStats(forms).distributionPlot(position);
end

function showSgenDensityHistogram(source, eventdata, forms, position)
  subplot('Position', position);
  retrieveSgenStats(forms).densityHistogram(position);
end

function showQueueSizePlot(source, eventdata, position)
  subplot('Position', position);
  global model;
  model.queueSizePlot();
end

function showAverageQueueSizePlot(source, eventdata, position)
  subplot('Position', position);
  global model;
  model.averageQueueSizePlot();
end

function showTransactionsInModelPlot(source, eventdata, position)
  subplot('Position', position);
  global model;
  model.transactionsInModelPlot();
end

function showAverageTransactionsInModelPlot(source, eventdata, position)
  subplot('Position', position);
  global model;
  model.averageTransactionsInModelPlot();
end

function showSystemUsagePlot(source, eventdata, position)
  subplot('Position', position);
  global model;
  model.systemUsagePlot();
end

window = figure(
  'Name', 'DESimulation',
  'NumberTitle', 'off',
  'Position', [0 0 windowX windowY]
);

% Modulation inputs labels
transactionsCountText = text('Количество транзактов', [0 0 0.4 0.05], fontSize);
MaText = text('Среднее время поступления заявки', [0 0.05 0.4 0.05], fontSize);
MsText = text('Среднее время обработки заявки', [0 0.1 0.4 0.05], fontSize);
handlersCountText = text('Количество устройств', [0 0.15 0.4 0.05], fontSize);
queueSizeText = text('Емкость накопителя', [0 0.2 0.4 0.05], fontSize);
handlingQuantText = text('Циклический квант', [0 0.25 0.4 0.05], fontSize);
AgenInitText = text('Начальное значение генератора времени поступления транзактов', [0 0.3 0.4 0.05], fontSize);
SgenInitText = text('Начальное значение генератора времени обработки транзактов', [0 0.35 0.4 0.05], fontSize);

% Modulation inputs
forms.transactionsCountInput = input(defaults.transactionsCount, [0.4 0 0.2 0.05]);
forms.MaInput = input(defaults.Ma, [0.4 0.05 0.2 0.05]);
forms.MsInput = input(defaults.Ms, [0.4 0.1 0.2 0.05]);
forms.handlersCountInput = input(defaults.handlersCount, [0.4 0.15 0.2 0.05]);
forms.queueSizeInput = input(defaults.queueSize, [0.4 0.2 0.2 0.05]);
forms.handlingQuantInput = input(defaults.handlingQuant, [0.4 0.25 0.2 0.05]);
forms.AgenInitInput = input(defaults.AgenInit, [0.4 0.3 0.2 0.05]);
forms.SgenInitInput = input(defaults.SgenInit, [0.4 0.35 0.2 0.05]);

% Stats labels
TText = text('Общее время работы', [0.6, 0, 0.3, 0.05], fontSize);
pText = text('Коэффициент использования системы', [0.6, 0.05, 0.3, 0.05], fontSize);
TqText = text('Cреднее время ожидания заявки в очереди', [0.6, 0.1, 0.3, 0.05], fontSize);
TsText = text('Cреднее время пребывания заявки в системе', [0.6, 0.15, 0.3, 0.05], fontSize);
NqText = text('Cреднее по времени число требований в очереди', [0.6, 0.2, 0.3, 0.05], fontSize);
NsText = text('Cреднее по времени число требований в системе', [0.6, 0.25, 0.3, 0.05], fontSize);
CaText = text('Абсолютная пропускная способность', [0.6, 0.3, 0.3, 0.05], fontSize);
CrText = text('Относительная пропускная способность', [0.6, 0.35, 0.3, 0.05], fontSize);

% Stats values
forms.TValue = text('NaN', [0.9, 0, 0.1, 0.05], numbersFontSize);
forms.pValue = text('NaN', [0.9, 0.05, 0.1, 0.05], numbersFontSize);
forms.TqValue = text('NaN', [0.9, 0.1, 0.1, 0.05], numbersFontSize);
forms.TsValue = text('NaN', [0.9, 0.15, 0.1, 0.05], numbersFontSize);
forms.NqValue = text('NaN', [0.9, 0.2, 0.1, 0.05], numbersFontSize);
forms.NsValue = text('NaN', [0.9, 0.25, 0.1, 0.05], numbersFontSize);
forms.CaValue = text('NaN', [0.9, 0.3, 0.1, 0.05], numbersFontSize);
forms.CrValue = text('NaN', [0.9, 0.35, 0.1, 0.05], numbersFontSize);

% Graphics btns
btn('времени поступления', [0.6, 0.45, 0.2, 0.05], {@showAgenDistributionPlot, forms, plotsPosition} , fontSize);
btn('времени обработки', [0.8, 0.45, 0.2, 0.05], {@showSgenDistributionPlot, forms, plotsPosition}, fontSize);
text('Графики функций распределения', [0.6, 0.5, 0.4, 0.05], fontSize);
btn('времени поступления', [0.6, 0.55, 0.2, 0.05], {@showAgenDensityHistogram, forms, plotsPosition}, fontSize);
btn('времени обработки', [0.8, 0.55, 0.2, 0.05], {@showSgenDensityHistogram, forms, plotsPosition}, fontSize);
text('Гистограммы плотностей распределения', [0.6, 0.6, 0.4, 0.05], fontSize);
btn('График по времени числа требований в очереди', [0.6, 0.65, 0.4, 0.05], {@showQueueSizePlot, plotsPosition}, fontSize);
btn('График по времени числа требований в системе', [0.6, 0.7, 0.4, 0.05], {@showTransactionsInModelPlot, plotsPosition}, fontSize);
btn('График по времени среднего числа требований в очереди', [0.6, 0.75, 0.4, 0.05], {@showAverageQueueSizePlot, plotsPosition}, fontSize);
btn('График по времени среднего числа требований в системе', [0.6, 0.8, 0.4, 0.05], {@showAverageTransactionsInModelPlot, plotsPosition}, fontSize);
btn('График по времени коэффициента использования системы', [0.6, 0.85, 0.4, 0.05], {@showSystemUsagePlot, plotsPosition}, fontSize);

% Modulation controls
forms.statusText = text(status.waiting, [0.2 0.9 0.8 0.1], headersFontSize);
forms.startModulationBtn = btn('Начать', [0 0.9 0.2 0.1], {@startModulation, forms, status});
