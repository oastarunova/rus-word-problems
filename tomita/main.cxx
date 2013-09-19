#encoding "utf-8"    // сообщаем парсеру о том, в какой кодировке написана грамматика
#GRAMMAR_ROOT S      // указываем корневой нетерминал грамматики
#GRAMMAR_KWSET ["bad_entities", "dimension", "metric", "pro"]
#include <numbers.cxx>

S -> WPNumber;
WPNumber -> Number<fw> interp (WPNum.WPid) Punct EOSent;           
RT -> Noun<rt, kwtype=none, gram="~ANUM,~APRO,~PR,anim"> interp (Entity.Root; Entity.EType="subject");
RT -> Noun<rt, kwtype=none, gram="~ANUM,~APRO,~PR,geo"> interp (Entity.Root; Entity.EType="geo");
RT -> Noun<rt, kwtype=none, gram="~ANUM,~APRO,~PR"> interp (Entity.Root; Entity.EType="object");
NNP -> RT NP<gram="gen">*;
//NNP -> Noun<rt, kwtype=none, gram="~ANUM,~APRO,~PR"> interp (Entity.Root; Entity.EType="object") NP<gram="gen">*;
NP -> Word<gnc-agr[1], gram="A,~APRO,~ANUM", kwtype=none>* NNP<gnc-agr[1], rt>; 
//NP -> Word<kwtype=none, gram="S,~gen,~APRO"> interp (Entity.Root);
S -> NP interp (Entity.Name);
Date -> AnyWord<kwtype="дата_авт">;
S -> Date;
Number -> AnyWord<kwtype="число_авт">;
Metric -> Word<kwtype=metric>;
Quantity -> Number interp (Metric.Value) Word<kwtype=none,gram="gen,~ANUM"> interp (Metric.Type="количество"; Metric.Unit; Entity.Name);
Quantity -> Number<rt> interp (Metric.Value) Metric<gram="gen"> interp (Metric.Type; Metric.Unit::not_norm);
Quantity -> 'в' Word<kwtype="время"> interp (Metric.Type; Metric.Unit::not_norm; Metric.Value="1");
Quantity -> 'за' Word<kwset=["время","количество"]>;
S -> Quantity;
S -> Quantity Noun<gram="gen">+ interp (Entity.Name);
S -> Word<gram="geo", kwtype=none> interp (Entity.Name; Entity.Root; Entity.EType="geo");

