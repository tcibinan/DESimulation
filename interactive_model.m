defaults.transactionsCount = '1000';
defaults.Ma = '10';
defaults.Ms = '10';
defaults.handlersCount = '2';
defaults.queueSize = '34';

global model forms;

function startModulation(source, eventdata, forms)
  transactionsCount = str2num(get(forms.transactionsCountInput, 'String'));
  Ma = str2num(get(forms.MaInput , 'String'));
  Ms = str2num(get(forms.MsInput , 'String'));
  handlersCount = str2num(get(forms.handlersCountInput , 'String'));
  queueSize = str2num(get(forms.queueSizeInput , 'String'));

  model = Model(transactionsCount, Ma, Ms, handlersCount, queueSize);
end

window = figure(
  'Name', 'DESimulation',
  'NumberTitle', 'off',
  'Position', [0 0 1000 500]
);

% Modulation inputs

forms.transactionsCountInput = uicontrol(
  'Style', 'edit',
  'String', defaults.transactionsCount,
  'Units', 'normalized',
  'Position', [0 0 0.2 0.05]
);
forms.MaInput = uicontrol(
  'Style', 'edit',
  'String', defaults.Ma,
  'Units', 'normalized',
  'Position', [0 0.05 0.2 0.05]
);
forms.MsInput = uicontrol(
  'Style', 'edit',
  'String', defaults.Ms,
  'Units', 'normalized',
  'Position', [0 0.1 0.2 0.05]
);
forms.handlersCountInput = uicontrol(
  'Style', 'edit',
  'String', defaults.handlersCount,
  'Units', 'normalized',
  'Position', [0 0.15 0.2 0.05]
);
forms.queueSizeInput = uicontrol(
  'Style', 'edit',
  'String', defaults.queueSize,
  'Units', 'normalized',
  'Position', [0 0.2 0.2 0.05]
);

% Modulation controls

forms.startModulationBtn = uicontrol(
  'Style', 'pushbutton',
  'String', 'Начать',
  'Units', 'normalized',
  'Position', [0 0.9 0.2 0.1],
  'Callback', {@startModulation, forms}
);

% Stats labels

forms.TText = uicontrol(
  'Style', 'text',
  'String', 'Общее время работы',
  'Units', 'normalized',
  'Position', [0.6, 0, 0.3, 0.05]
);
forms.qText = uicontrol(
  'Style', 'text',
  'String', 'Коэффициент использования системы',
  'Units', 'normalized',
  'Position', [0.6, 0.05, 0.3, 0.05]
);
forms.pText = uicontrol(
  'Style', 'text',
  'String', '',
  'Units', 'normalized',
  'Position', [0.6, 0.1, 0.3, 0.05]
);
forms.TqText = uicontrol(
  'Style', 'text',
  'String', '',
  'Units', 'normalized',
  'Position', [0.6, 0.15, 0.3, 0.05]
);
forms.TsText = uicontrol(
  'Style', 'text',
  'String', '',
  'Units', 'normalized',
  'Position', [0.6, 0.2, 0.3, 0.05]
);
forms.NqText = uicontrol(
  'Style', 'text',
  'String', '',
  'Units', 'normalized',
  'Position', [0.6, 0.25, 0.3, 0.05]
);
forms.NsText = uicontrol(
  'Style', 'text',
  'String', '',
  'Units', 'normalized',
  'Position', [0.6, 0.3, 0.3, 0.05]
);
forms.CaText = uicontrol(
  'Style', 'text',
  'String', '',
  'Units', 'normalized',
  'Position', [0.6, 0.35, 0.3, 0.05]
);
forms.CrText = uicontrol(
  'Style', 'text',
  'String', '',
  'Units', 'normalized',
  'Position', [0.6, 0.4, 0.3, 0.05]
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
