#encoding "utf-8"    // сообщаем парсеру о том, в какой кодировке написана грамматика
#GRAMMAR_ROOT S      // указываем корневой нетерминал грамматики

Bad -> Word<GU=&[APRO]>;
Bad -> Word<GU=&[ANUM]>;
Bad -> Word<GU=&[PR]>;
Bad -> Word<GU=&[S,ADVPRO]>;
S -> Bad;
