#encoding "utf-8"    // сообщаем парсеру о том, в какой кодировке написана грамматика
#GRAMMAR_ROOT S      // указываем корневой нетерминал грамматики
#GRAMMAR_KWSET ["bad_entities", "dimension", "metric", "pro"]
#include <numbers.cxx>

S -> WPNumber;
WPNumber -> Number<fw> interp (WPNum.WPid) Punct EOSent;           
NP -> Word<gnc-agr[1], gram="A,~APRO,~ANUM", kwtype=none>* Word<gnc-agr[1], rt, kwtype=none, gram="S,~ANUM,~APRO"> interp (Entity.Root) Noun<gram="gen", kwtype=none>*;
NP -> Word<kwtype=none, gram="S,~gen,~APRO"> interp (Entity.Root);
S -> NP interp (Entity.Name);
Date -> AnyWord<kwtype="дата_авт">;
S -> Date;
Number -> AnyWord<kwtype="число_авт">;
//Number -> Word<gram="ANUM">+;
Metric -> Word<kwtype=metric>;
Quantity -> Number interp (Metric.Value) Word<kwtype=none,gram="gen,~ANUM"> interp (Metric.Type="количество"; Metric.Unit; Entity.Name);
Quantity -> Number<rt> interp (Metric.Value) Metric<gram="gen"> interp (Metric.Type; Metric.Unit::not_norm);
Quantity -> 'в' Word<kwtype="время"> interp (Metric.Type; Metric.Unit::not_norm; Metric.Value="1");
Quantity -> 'за' Word<kwset=["время","количество"]>;
S -> Quantity;
S -> Quantity Noun<gram="gen">+ interp (Entity.Name);
/*
CmpMeasure -> "на" Quantity;
CmpMeasure -> "в" AnyWord<kwtype="число_авт"> "раз";
Dim -> Word<kwtype="размерность"> Word<gram="gen">+;
Comparative -> (CmpMeasure) NP Adj<gram="comp"> NP; 
Comparative -> CmpMeasure Adj<gram="comp"> NP; 
Comparative -> NP CmpMeasure Adj<gram="comp"> NP; 
Comparative -> NP Adj<gram="comp"> CmpMeasure; 
Comparative -> NP Adj<gram="comp"> NP CmpMeasure;
Distance -> ('расстояние') 'от' NP<gram="gen"> 'до' NP<gram="gen">;
Distance -> 'из' NP<gram="gen"> 'в' NP<gram="acc">;
//VP -> NP Verb<gram="indic">;
//S -> VP;
Personage -> (Adj<gnc-agr[1]>) Noun<gnc-agr[1], gram="anim", rt>;
S -> Comparative;
S -> Dim;
S -> Distance;
//S -> Personage;
*/
