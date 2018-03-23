defaults.transactionsCount = '1000';
defaults.Ma = '10';
defaults.Ms = '10';
defaults.handlersCount = '2';
defaults.queueSize = '34';
defaults.AgenInit = '42342341';
defaults.SgenInit = '342452';
defaults.handlingQuant = '1';

fontSize = 8;
status.waiting = 'Статус: Ожидание.';
status.modelling = 'Статус: Моделирование в процессе...';
status.error = 'Статус: Моделирование завершено с ошибкой.';
status.finished = 'Статус: Моделирование завершено.';

function startModulation(source, eventdata, forms, status)
  transactionsCount = str2num(get(forms.transactionsCountInput, 'String'));
  Ma = str2num(get(forms.MaInput , 'String'));
  Ms = str2num(get(forms.MsInput , 'String'));
  handlersCount = str2num(get(forms.handlersCountInput , 'String'));
  handlingQuant = str2num(get(forms.handlingQuantInput , 'String'));
  queueSize = str2num(get(forms.queueSizeInput , 'String'));
  Agen = PuassonGenerator(
    LinearCongruentialGenerator(str2num(get(forms.AgenInitInput, 'String'))),
    Ma
  );
  Sgen = PuassonGenerator(
    LinearCongruentialGenerator(str2num(get(forms.SgenInitInput, 'String'))),
    Ms
  );

  model = Model(transactionsCount, Ma, Ms, handlersCount, handlingQuant, queueSize, Agen, Sgen);

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

window = figure(
  'Name', 'DESimulation',
  'NumberTitle', 'off',
  'Position', [0 0 1000 500]
);

% Modulation inputs labels

transactionsCountText = uicontrol(
  'Style', 'text',
  'String', 'Количество транзактов',
  'Units', 'normalized',
  'Position', [0 0 0.4 0.05],
  'FontSize', fontSize
);
MaText = uicontrol(
  'Style', 'text',
  'String', 'Среднее время поступления заявки',
  'Units', 'normalized',
  'Position', [0 0.05 0.4 0.05],
  'FontSize', fontSize
);
MsText = uicontrol(
  'Style', 'text',
  'String', 'Среднее время обработки заявки',
  'Units', 'normalized',
  'Position', [0 0.1 0.4 0.05],
  'FontSize', fontSize
);
handlersCountText = uicontrol(
  'Style', 'text',
  'String', 'Количество устройств',
  'Units', 'normalized',
  'Position', [0 0.15 0.4 0.05],
  'FontSize', fontSize
);
queueSizeText = uicontrol(
  'Style', 'text',
  'String', 'Емкость накопителя',
  'Units', 'normalized',
  'Position', [0 0.2 0.4 0.05],
  'FontSize', fontSize
);
handlingQuantText = uicontrol(
  'Style', 'text',
  'String', 'Циклический квант',
  'Units', 'normalized',
  'Position', [0 0.25 0.4 0.05],
  'FontSize', fontSize
);
AgenInitText = uicontrol(
  'Style', 'text',
  'String', 'Начальное значение генератора времени поступления транзактов',
  'Units', 'normalized',
  'Position', [0 0.3 0.4 0.05],
  'FontSize', fontSize
);
SgenInitText = uicontrol(
  'Style', 'text',
  'String', 'Начальное значение генератора времени обработки транзактов',
  'Units', 'normalized',
  'Position', [0 0.35 0.4 0.05],
  'FontSize', fontSize
);

% Modulation inputs

forms.transactionsCountInput = uicontrol(
  'Style', 'edit',
  'String', defaults.transactionsCount,
  'Units', 'normalized',
  'Position', [0.4 0 0.2 0.05]
);
forms.MaInput = uicontrol(
  'Style', 'edit',
  'String', defaults.Ma,
  'Units', 'normalized',
  'Position', [0.4 0.05 0.2 0.05]
);
forms.MsInput = uicontrol(
  'Style', 'edit',
  'String', defaults.Ms,
  'Units', 'normalized',
  'Position', [0.4 0.1 0.2 0.05]
);
forms.handlersCountInput = uicontrol(
  'Style', 'edit',
  'String', defaults.handlersCount,
  'Units', 'normalized',
  'Position', [0.4 0.15 0.2 0.05]
);
forms.queueSizeInput = uicontrol(
  'Style', 'edit',
  'String', defaults.queueSize,
  'Units', 'normalized',
  'Position', [0.4 0.2 0.2 0.05]
);
forms.handlingQuantInput = uicontrol(
  'Style', 'edit',
  'String', defaults.handlingQuant,
  'Units', 'normalized',
  'Position', [0.4 0.25 0.2 0.05]
);
forms.AgenInitInput = uicontrol(
  'Style', 'edit',
  'String', defaults.AgenInit,
  'Units', 'normalized',
  'Position', [0.4 0.3 0.2 0.05]
);
forms.SgenInitInput = uicontrol(
  'Style', 'edit',
  'String', defaults.SgenInit,
  'Units', 'normalized',
  'Position', [0.4 0.35 0.2 0.05]
);

% Stats labels

TText = uicontrol(
  'Style', 'text',
  'String', 'Общее время работы',
  'Units', 'normalized',
  'Position', [0.6, 0, 0.3, 0.05],
  'FontSize', fontSize
);
qText = uicontrol(
  'Style', 'text',
  'String', '',
  'Units', 'normalized',
  'Position', [0.6, 0.05, 0.3, 0.05],
  'FontSize', fontSize
);
pText = uicontrol(
  'Style', 'text',
  'String', 'Коэффициент использования системы',
  'Units', 'normalized',
  'Position', [0.6, 0.1, 0.3, 0.05],
  'FontSize', fontSize
);
TqText = uicontrol(
  'Style', 'text',
  'String', 'Cреднее время ожидания заявки в очереди',
  'Units', 'normalized',
  'Position', [0.6, 0.15, 0.3, 0.05],
  'FontSize', fontSize
);
TsText = uicontrol(
  'Style', 'text',
  'String', 'Cреднее время пребывания заявки в системе',
  'Units', 'normalized',
  'Position', [0.6, 0.2, 0.3, 0.05],
  'FontSize', fontSize
);
NqText = uicontrol(
  'Style', 'text',
  'String', 'Cреднее по времени число требований в очереди',
  'Units', 'normalized',
  'Position', [0.6, 0.25, 0.3, 0.05],
  'FontSize', fontSize
);
NsText = uicontrol(
  'Style', 'text',
  'String', 'Cреднее по времени число требований в системе',
  'Units', 'normalized',
  'Position', [0.6, 0.3, 0.3, 0.05],
  'FontSize', fontSize
);
CaText = uicontrol(
  'Style', 'text',
  'String', 'Абсолютная пропускная способность',
  'Units', 'normalized',
  'Position', [0.6, 0.35, 0.3, 0.05],
  'FontSize', fontSize
);
CrText = uicontrol(
  'Style', 'text',
  'String', 'Относительная пропускная способность',
  'Units', 'normalized',
  'Position', [0.6, 0.4, 0.3, 0.05],
  'FontSize', fontSize
);

% Stats values

forms.TValue = uicontrol(
  'Style', 'text',
  'String', 'NaN',
  'Units', 'normalized',
  'Position', [0.9, 0, 0.1, 0.05]
);
forms.qValue = uicontrol(
  'Style', 'text',
  'String', 'NaN',
  'Units', 'normalized',
  'Position', [0.9, 0.05, 0.1, 0.05]
);
forms.pValue = uicontrol(
  'Style', 'text',
  'String', 'NaN',
  'Units', 'normalized',
  'Position', [0.9, 0.1, 0.1, 0.05]
);
forms.TqValue = uicontrol(
  'Style', 'text',
  'String', 'NaN',
  'Units', 'normalized',
  'Position', [0.9, 0.15, 0.1, 0.05]
);
forms.TsValue = uicontrol(
  'Style', 'text',
  'String', 'NaN',
  'Units', 'normalized',
  'Position', [0.9, 0.2, 0.1, 0.05]
);
forms.NqValue = uicontrol(
  'Style', 'text',
  'String', 'NaN',
  'Units', 'normalized',
  'Position', [0.9, 0.25, 0.1, 0.05]
);
forms.NsValue = uicontrol(
  'Style', 'text',
  'String', 'NaN',
  'Units', 'normalized',
  'Position', [0.9, 0.3, 0.1, 0.05]
);
forms.CaValue = uicontrol(
  'Style', 'text',
  'String', 'NaN',
  'Units', 'normalized',
  'Position', [0.9, 0.35, 0.1, 0.05]
);
forms.CrValue = uicontrol(
  'Style', 'text',
  'String', 'NaN',
  'Units', 'normalized',
  'Position', [0.9, 0.4, 0.1, 0.05]
);

% Modulation controls

forms.statusText = uicontrol(
  'Style', 'text',
  'String', status.waiting,
  'Units', 'normalized',
  'Position', [0.2 0.9 0.8 0.1]
);

forms.startModulationBtn = uicontrol(
  'Style', 'pushbutton',
  'String', 'Начать',
  'Units', 'normalized',
  'Position', [0 0.9 0.2 0.1],
  'Callback', {@startModulation, forms, status}
);
