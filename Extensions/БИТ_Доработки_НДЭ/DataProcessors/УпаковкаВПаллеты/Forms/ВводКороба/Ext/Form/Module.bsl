
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	 //////////////////////////////////
	// Получаем параметры
	Если Параметры.Свойство("МассивСвободныхШКУпакованныхКоробов") Тогда
		МассивСвободныхШКУпакованныхКоробов = Новый ХранилищеЗначения(Параметры.МассивСвободныхШКУпакованныхКоробов);
	КонецЕсли;
	
	Если Параметры.Свойство("СколькоУжеУпакованоВПаллет") Тогда
		СколькоУжеУпакованоВПаллет = Параметры.СколькоУжеУпакованоВПаллет;
	КонецЕсли;
	
	Если Параметры.Свойство("Вместимость") Тогда
		Вместимость = Параметры.Вместимость;
	КонецЕсли;
	
	Если Параметры.Свойство("ИспользуемыйСклад") Тогда
		ИспользуемыйСклад = Параметры.ИспользуемыйСклад;
		Элементы.КартинкаСканирования.Видимость = Истина;
		Если ИспользуемыйСклад = 1 Тогда
			Элементы.КартинкаСканирования.Картинка = БиблиотекаКартинок.БИТ_КартинкаСканированияШККоробаОЗОНПаллет;
		ИначеЕсли ИспользуемыйСклад = 2 Тогда
			Элементы.КартинкаСканирования.Картинка = БиблиотекаКартинок.БИТ_КартинкаСканированияШККоробаВБПаллет;
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("ШКПаллета") Тогда
		ШКПаллета = Параметры.ШКПаллета;
	КонецЕсли;
	
	Если Параметры.Свойство("СколькоВПоследнемПаллетеВместимость") Тогда
		Объект.СколькоВПоследнемПаллетеВместимость = Параметры.СколькоВПоследнемПаллетеВместимость;
	КонецЕсли;
	Если Параметры.Свойство("ДокументОснование") Тогда
		Объект.ДокументОснование = Параметры.ДокументОснование;
	КонецЕсли;
	Если Параметры.Свойство("ЗаказПокупателяСсылка") Тогда
		Объект.ЗаказПокупателяСсылка = Параметры.ЗаказПокупателяСсылка;
	КонецЕсли;
	Если Параметры.Свойство("СтрокаНумерацииУпакованных") Тогда
		Если Параметры.СтрокаНумерацииУпакованных <>"" ИЛИ Параметры.СтрокаНумерацииУпакованных <> Неопределено Тогда
			СтрокаНумерацииУпакованных = Параметры.СтрокаНумерацииУпакованных;
		КонецЕсли;
	КонецЕсли;
	
	//Монопаллеты
	Если Параметры.Свойство("ШтрихкодМонопаллета") Тогда
		ШтрихкодМонопаллета = Параметры.ШтрихкодМонопаллета;
	КонецЕсли;
	Если Параметры.Свойство("МоноПаллет") Тогда
		МоноПаллет = Параметры.МоноПаллет;
		Если МоноПаллет = Истина И ЗначениеЗаполнено(ШтрихкодМонопаллета) И ЗначениеЗаполнено(ШКПаллета) Тогда
			
			РазрешеннаяНоменклатураДляВводаВМонопаллет = ПолучитьРазрешеннуюНоменклатуру(ШтрихкодМонопаллета, ШКПаллета);
			Если РазрешеннаяНоменклатураДляВводаВМонопаллет = Неопределено Тогда
				ВызватьИсключение("Не удалось получить разрешенную номенклатуру для монопаллета!");
			КонецЕсли;
			Если РазрешеннаяНоменклатураДляВводаВМонопаллет.Количество() < 1 Тогда
				ВызватьИсключение("Нет разрешенной номенклатуры для монопаллета!");
			КонецЕсли;
			
			Элементы.НоменклатураСборки.Видимость = Истина;
			НоменклатураСборки = "Разрешенная номенклатура в паллетах для коробов: ";
			
			Для Каждого РазрешеннаяНоменклатура Из РазрешеннаяНоменклатураДляВводаВМонопаллет Цикл
				НоменклатураСборки = НоменклатураСборки + Строка(РазрешеннаяНоменклатура.НоменклатураДляМонопаллета) + "("
				+ Строка(РазрешеннаяНоменклатура.БаркодТовара) + ")";
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	ШККоробаУжеВведен = Ложь;
	ШКМонопаллетУжеВведен = Ложь;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРазрешеннуюНоменклатуру(ШтрихкодМонопаллета, ШКПаллета)
	
	Если ШтрихкодМонопаллета = "" Или ШтрихкодМонопаллета = Неопределено Тогда
		Сообщить("Ошибка: не указан штрихкод Монопаллета");
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ШтрихкодыМонопаллетов.НоменклатураДляМонопаллета КАК НоменклатураДляМонопаллета,
	|	ШтрихкодыМонопаллетов.БаркодТовара КАК БаркодТовара
	|ИЗ
	|	РегистрСведений.ШтрихкодыМонопаллетов КАК ШтрихкодыМонопаллетов
	|ГДЕ
	|	ШтрихкодыМонопаллетов.ДокументОснование = &ДокументОснование
	|	И ШтрихкодыМонопаллетов.ШтрихкодМонопаллета = &ШтрихкодМонопаллета
	|	И ШтрихкодыМонопаллетов.ШтрихкодПаллета = &ШтрихкодПаллета";
	
	Запрос.УстановитьПараметр("ДокументОснование", Объект.ЗаказПокупателяСсылка);
	Запрос.УстановитьПараметр("ШтрихкодМонопаллета", ШтрихкодМонопаллета);
	Запрос.УстановитьПараметр("ШтрихкодПаллета", ШКПаллета);
	
	Попытка
		РезультатЗапроса = Запрос.Выполнить();
	Исключение
		// Логирование ошибки (опционально)
		// ЗаписьЖурналаРегистрации("Ошибка запроса паллет", УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Возврат Неопределено;
	КонецПопытки;
	
	//Есть ли данные в результате
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	//Выгрузка результата с обработкой ошибок
	Попытка
		ТаблицаРазрешеннойНоменклатуры = РезультатЗапроса.Выгрузить();
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат ТаблицаРазрешеннойНоменклатуры;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    // Устанавливаем обработчик ожидания, который сработает через 1 секунду
    WSHShell = Новый COMОбъект("WScript.Shell");
    WSHShell.SendKeys("% ");
    WSHShell.SendKeys("{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}");
КонецПроцедуры

&НаСервере
Функция ПолучитьМассивИзХранилища(Хранилище)
    Если Хранилище = Неопределено Тогда
        Возврат Новый Массив;
    КонецЕсли;
    Возврат Хранилище.Получить();
КонецФункции

&НаКлиенте
Процедура КнопкаОКНажатие(Команда)
	
	Если СколькоУжеУпакованоВПаллет = Вместимость - 1 ИЛИ (СколькоУжеУпакованоВПаллет = Объект.СколькоВПоследнемПаллетеВместимость-1 И ПолучитьВместимостьПаллета(ШКПаллета) <> 30) Тогда
		Если Не ШККоробаУжеВведен Тогда
			//Скан Штрихкода короба при печати ШКПаллета
			МассивСвободныхШК = ПолучитьМассивИзХранилища(МассивСвободныхШКУпакованныхКоробов);
			ИндексМассива = МассивСвободныхШК.Найти(ВведенныйКод);
			Если ИндексМассива <> Неопределено Тогда
				ОчиститьСообщения();
				ТекстПодсказки = "ШТРИХКОД верный " + ВведенныйКод;
				СохраненныйШКПриПечатиШКПаллета = ВведенныйКод;
				ШККоробаУжеВведен = Истина;
				СтрокаНумерацииУпакованных = "Паллет собран";
				
				//проверка если монопаллет, сначала печатаем монопаллет
				Если МоноПаллет = Истина Тогда
					Элементы.КартинкаСканирования.Картинка = БиблиотекаКартинок.БИТ_КартинкаСканированияШКМоноПаллета;
					ОзвучитьТекст("Наклейте на МоноПаллет Штрихкод и отсканируйте его");
					ПечатьКМ(ШтрихкодМонопаллета, "ШтрихкодМонопаллета");
				Иначе
					Элементы.КартинкаСканирования.Картинка = БиблиотекаКартинок.БИТ_КартинкаСканированияШКПаллета;
					ОзвучитьТекст("Наклейте на паллет КИТУ и отсканируйте его");
					ПечатьКМ(ШКПаллета, "Паллет");
				КонецЕсли;
				
				ВведенныйКод = "";
				Возврат;
				
			Иначе
				//если шк короба не верно ввели
				ОчиститьСообщения();
				ТекстПодсказки = "Ошибка: Введен неверный ШТРИХКОД короба для паллета с ШК:" + ШКПаллета;
				HTMLЗвук = "";
				ПодключитьОбработчикОжидания("ПроигратьЗвукОшибкиСканирования" ,0.1, Истина); // 0.1 секунды задержки
				ВведенныйКод = "";
				Возврат; 
			КонецЕсли;
			
		Иначе
			//проверка если монопаллет, то проверяем монопаллет
			Если МоноПаллет = Истина И НЕ ШКМонопаллетУжеВведен Тогда
				Если ВведенныйКод = ШтрихкодМонопаллета Тогда
					ОчиститьСообщения();
					ТекстПодсказки = "ШТРИХКОД Монопаллета верный " + ВведенныйКод;
					ШКМонопаллетУжеВведен = Истина;
					Элементы.КартинкаСканирования.Картинка = БиблиотекаКартинок.БИТ_КартинкаСканированияШКПаллета;
					ОзвучитьТекст("Наклейте на паллет КИТУ и отсканируйте его");
					ПечатьКМ(ШКПаллета, "Паллет");
					ВведенныйКод = "";
					Возврат;
				Иначе
					ОчиститьСообщения();
					ТекстПодсказки = "Ошибка: Введен неверный ШТРИХКОД Монопаллета" + ВведенныйКод;
					HTMLЗвук = "";
					ПодключитьОбработчикОжидания("ПроигратьЗвукОшибкиСканирования" ,0.1, Истина); // 0.1 секунды задержки
					ВведенныйКод = "";
					Возврат;
				КонецЕсли;
			КонецЕсли;
			
			
			//логика для сканирования паллета
			Если ВведенныйКод = ШКПаллета Тогда
				ОчиститьСообщения();
				ТекстПодсказки = "ШТРИХКОД паллета верный " + ВведенныйКод;
				Закрыть(СохраненныйШКПриПечатиШКПаллета);
			Иначе
				ОчиститьСообщения();
				ТекстПодсказки = "Ошибка: Введен неверный ШТРИХКОД паллета" + ВведенныйКод;
				HTMLЗвук = "";
				ПодключитьОбработчикОжидания("ПроигратьЗвукОшибкиСканирования" ,0.1, Истина); // 0.1 секунды задержки
				ВведенныйКод = "";
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		//если сканируем не последний
		МассивСвободныхШК = ПолучитьМассивИзХранилища(МассивСвободныхШКУпакованныхКоробов);
		ИндексМассива = МассивСвободныхШК.Найти(ВведенныйКод);
		Если ИндексМассива <> Неопределено Тогда
			ОчиститьСообщения();
			ТекстПодсказки = "ШТРИХКОД верный " + ВведенныйКод;
			Закрыть(ВведенныйКод);
		Иначе
			ОчиститьСообщения();
			ТекстПодсказки = "Ошибка: Введен неверный ШТРИХКОД короба для паллета с ШК:" + ШКПаллета;
			HTMLЗвук = "";
			ПодключитьОбработчикОжидания("ПроигратьЗвукОшибкиСканирования" ,0.1, Истина); // 0.1 секунды задержки
			ВведенныйКод = "";
			Возврат;
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВместимостьПаллета(ШКПаллета)
	
	Если ШКПаллета = "" Или ШКПаллета = Неопределено Тогда
		Сообщить("Ошибка: не указан штрихкод паллета");
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ШтрихкодыПаллетов.Вместимость КАК Вместимость
	|ИЗ
	|	РегистрСведений.ШтрихкодыПаллетов КАК ШтрихкодыПаллетов
	|ГДЕ
	|	ШтрихкодыПаллетов.ДокументОснование = &ДокументОснование
	|	И ШтрихкодыПаллетов.ШтрихкодПаллета = &ШтрихкодПаллета";
	
	Запрос.УстановитьПараметр("ДокументОснование", Объект.ДокументОснование);
	Запрос.УстановитьПараметр("ШтрихкодПаллета", ШКПаллета);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	// 2. Обновляем найденные записи через набор записей
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Вместимость;
	КонецЕсли;
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура КнопкаОтменаНажатие(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	Если Не ВводДоступен() Тогда
		Сообщить("Ввод не доступен");
		Возврат;
	КонецЕсли;
	
	// Обработка сканера
	//Источник пример:"InputDevice#727045279231", событие пример:"Штрихкод" - типы "Строка"
	Если Событие = "Штрихкод" Тогда
		Данные = Строка(Данные);
		
		Если СтрДлина(Данные) > 15 И НЕ ШККоробаУжеВведен Тогда//у шк длина 14, уже скан шк короба
			ТекстПодсказки = "Вы сканируете КМ, а необходимо ШТРИХКОД !";
			HTMLЗвук = "";
			ПодключитьОбработчикОжидания("ПроигратьЗвукОшибкиСканирования" ,0.1, Истина); // 0.1 секунды задержки
			Возврат;
		КонецЕсли;
		
		
		Если СколькоУжеУпакованоВПаллет = Вместимость - 1 ИЛИ (СколькоУжеУпакованоВПаллет = Объект.СколькоВПоследнемПаллетеВместимость-1 И ПолучитьВместимостьПаллета(ШКПаллета) <> 30) Тогда
			Если Не ШККоробаУжеВведен Тогда
				//Скан Штрихкода короба при печати ШКПаллета
				МассивСвободныхШК = ПолучитьМассивИзХранилища(МассивСвободныхШКУпакованныхКоробов);
				ИндексМассива = МассивСвободныхШК.Найти(Данные);
				Если ИндексМассива <> Неопределено Тогда
					ОчиститьСообщения();
					ТекстПодсказки = "ШТРИХКОД верный " + Данные;
					СохраненныйШКПриПечатиШКПаллета = Данные;
					ШККоробаУжеВведен = Истина;
					СтрокаНумерацииУпакованных = "Паллет собран";
					
					//проверка если монопаллет, сначала печатаем монопаллет
					Если МоноПаллет = Истина Тогда
						Элементы.КартинкаСканирования.Картинка = БиблиотекаКартинок.БИТ_КартинкаСканированияШКМоноПаллета;
						ОзвучитьТекст("Наклейте на МоноПаллет Штрихкод и отсканируйте его");
						ПечатьКМ(ШтрихкодМонопаллета, "ШтрихкодМонопаллета");
					Иначе
						Элементы.КартинкаСканирования.Картинка = БиблиотекаКартинок.БИТ_КартинкаСканированияШКПаллета;
						ОзвучитьТекст("Наклейте на паллет КИТУ и отсканируйте его");
						ПечатьКМ(ШКПаллета, "Паллет");
					КонецЕсли;
					
					ВведенныйКод = "";
					Возврат;
				Иначе
					ОчиститьСообщения();
					ТекстПодсказки = "Ошибка: Введен неверный ШТРИХКОД короба для паллета с ШК:" + ШКПаллета;
					HTMLЗвук = "";
					ПодключитьОбработчикОжидания("ПроигратьЗвукОшибкиСканирования" ,0.1, Истина); // 0.1 секунды задержки
					ВведенныйКод = "";
					Возврат; 
				КонецЕсли;
				
			Иначе
				
				//проверка если монопаллет, то проверяем монопаллет
				Если МоноПаллет = Истина И НЕ ШКМонопаллетУжеВведен Тогда
					Если Данные = ШтрихкодМонопаллета Тогда
						ОчиститьСообщения();
						ТекстПодсказки = "ШТРИХКОД Монопаллета верный " + Данные;
						ШКМонопаллетУжеВведен = Истина;
						Элементы.КартинкаСканирования.Картинка = БиблиотекаКартинок.БИТ_КартинкаСканированияШКПаллета;
						ОзвучитьТекст("Наклейте на паллет КИТУ и отсканируйте его");
						ПечатьКМ(ШКПаллета, "Паллет");
						ВведенныйКод = "";
						Возврат;
					Иначе
						ОчиститьСообщения();
						ТекстПодсказки = "Ошибка: Введен неверный ШТРИХКОД Монопаллета" + Данные;
						HTMLЗвук = "";
						ПодключитьОбработчикОжидания("ПроигратьЗвукОшибкиСканирования" ,0.1, Истина); // 0.1 секунды задержки
						ВведенныйКод = "";
						Возврат;
					КонецЕсли;
				КонецЕсли;
				
				//логика для сканирования паллета
				Данные = "(" + Сред(Данные,0,2)+")"+Сред(Данные,3,СтрДлина(Данные)-2);
				Если Данные = ШКПаллета Тогда
					ОчиститьСообщения();
					ТекстПодсказки = "ШТРИХКОД паллета верный " + Данные;
					Закрыть(СохраненныйШКПриПечатиШКПаллета);
				Иначе
					ОчиститьСообщения();
					ТекстПодсказки = "Ошибка: Введен неверный ШТРИХКОД паллета" + Данные;
					HTMLЗвук = "";
					ПодключитьОбработчикОжидания("ПроигратьЗвукОшибкиСканирования" ,0.1, Истина); // 0.1 секунды задержки
					ВведенныйКод = "";
					Возврат;
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			
			МассивСвободныхШК = ПолучитьМассивИзХранилища(МассивСвободныхШКУпакованныхКоробов);
			ИндексМассива = МассивСвободныхШК.Найти(Данные);
			Если ИндексМассива <> Неопределено Тогда
				ОчиститьСообщения();
				ТекстПодсказки = "ШТРИХКОД верный " + Данные;
				Закрыть(Данные);
			Иначе
				ОчиститьСообщения();
				ТекстПодсказки = "Ошибка: Введен неверный ШТРИХКОД короба для паллета с ШК:" + ШКПаллета;
				HTMLЗвук = "";
				ПодключитьОбработчикОжидания("ПроигратьЗвукОшибкиСканирования" ,0.1, Истина); // 0.1 секунды задержки
				ВведенныйКод = "";
				Возврат;
			КонецЕсли;
				
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОзвучитьТекст(ТекстДляОзвучки)
	
	Попытка
		// 1. Создаем COM-объект голосового движка Windows
		Голос = Новый COMОбъект("SAPI.SpVoice");
		
		// Пример для голоса "Pavel" из Windows 10/11
		Голос.Voice = Голос.GetVoices().Item(0); // Первый доступный голос
		// Или указать конкретный из реестра:
		// Голос.Voice.Category.Default = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Speech_OneCore\Voices\Tokens\MSTTS_V110_ruRU_PavelM";
		
		//// берем последний
		//Для Индекс = 0 По Голос.GetVoices().Count - 1 Цикл
		//	Голос.Voice = Голос.GetVoices().Item(Индекс);
		//КонецЦикла;
		
		// 2. Устанавливаем громкость (0 - 100)
		Голос.Volume = 100;
		
		// 3. Выбираем скорость речи (-10 - 10). 0 - средняя
		Голос.Rate = 0;
		
		// 4. Произносим текст
		Голос.Speak(ТекстДляОзвучки);
		
	Исключение
		Сообщить("Не удалось воспроизвести речь: " + ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры



///////////////////////////////////ПЕЧАТЬ/////////////////////////////////////////////////////////////////////
&НаКлиенте
Процедура ПечатьКМ(ВведенныйШтрихкод, ШаблонПечати)
	
	Если Не ЗначениеЗаполнено(ВведенныйШтрихкод) Тогда
		Сообщить("Введите штрихкод");
		Возврат;
	КонецЕсли;
	
	// Поиск упаковки по штрихкоду на сервере
	НайденнаяУпаковка = ПоискУпаковкиПоШтрихкодуНаСервере(ВведенныйШтрихкод);
	
	Если НайденнаяУпаковка = "" Тогда
		Сообщить("Упаковка со штрихкодом """ + ВведенныйШтрихкод + """ не найдена");//убрать в сообщение
		Возврат;
	КонецЕсли;
	
	// Получаем шаблон этикетки из справочника ХранилищеШаблонов
	ШаблонЭтикетки = ПолучитьШаблонЭтикеткиНаСервере(ШаблонПечати);
	
	Если ШаблонЭтикетки = "" Тогда
		Сообщить("Не найден шаблон этикетки");
		Возврат;
	КонецЕсли;
	
	// Формируем описание команды для печати
	ОписаниеКоманды = Новый Структура;
	ОписаниеКоманды.Вставить("Идентификатор", "ЭтикеткаКодМаркировкиИСМП");
	ОписаниеКоманды.Вставить("ОбъектыПечати", Новый Массив);
	ОписаниеКоманды.ОбъектыПечати.Добавить(НайденнаяУпаковка);
	ОписаниеКоманды.Вставить("Форма", ЭтаФорма); 
	ОписаниеКоманды.Вставить("ШаблонЭтикетки", ШаблонЭтикетки);
	
	// Получаем данные для печати
	ОбъектыПечати = ПечатьЭтикетокИСМПВызовСервера.ДанныеДляПечатиШтрихкодовУпаковокИСМП(
		ОписаниеКоманды.Идентификатор,
		ОписаниеКоманды.ОбъектыПечати,
		Новый Массив()); // МассивШаблоновКодовМаркировок сразу создаем
	
	Если ОбъектыПечати.Количество() = 0 Тогда
		Сообщить(НСтр("ru='Нет данных для печати этикеток.'"));
		Возврат;
	КонецЕсли;
	
	// Формируем параметры открытия формы
	ПараметрыОткрытия = Новый Структура(
		"АдресВХранилище, Шаблоны", 
		ПоместитьВоВременноеХранилище(Новый Структура("РежимПечати, ОбъектыПечати", "Выборочно", ОбъектыПечати)),
		Новый Массив());
		
		
	ПараметрыОткрытия.Вставить("СразуНаПринтер", Истина);
	ПараметрыОткрытия.Вставить("ШаблонЭтикетки", ШаблонЭтикетки);
	
	ДанныеП = выполнитьПечатьНаСервере(ПараметрыОткрытия);
	ВыполнитьПечатьДока(ДанныеП,ВведенныйШтрихкод, ШаблонПечати);
КонецПроцедуры

&НаСервере
Функция выполнитьПечатьНаСервере(ПараметрыОткрытия)
	СразуНаПринтер        = ПараметрыОткрытия.СразуНаПринтер;
	КоличествоЭкземпляров = 1;
	ШаблонЭтикетки        = ПараметрыОткрытия.ШаблонЭтикетки;
	
	Если ЗначениеЗаполнено(ПараметрыОткрытия.АдресВХранилище) Тогда
	АдресВХранилище = ПоместитьВоВременноеХранилище(
		ПолучитьИзВременногоХранилища(ПараметрыОткрытия.АдресВХранилище),
		УникальныйИдентификатор);
	КонецЕсли;
	
	ДанныеПечати = ПолучитьИзВременногоХранилища(АдресВХранилище);
	Для Каждого СтрокаПечати Из ДанныеПечати.ОбъектыПечати Цикл
		СтрокаПечати.ШаблонЭтикетки = ШаблонЭтикетки;
	КонецЦикла;
	
	Возврат ДанныеПечати;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПечатьДока(ДанныеП,ВведенныйШтрихкод, ШаблонПечати)
	
	ПараметрКоманды = Новый Массив;
	ПараметрКоманды.Добавить(ПредопределенноеЗначение("Справочник.ШтрихкодыУпаковокТоваров.ПустаяСсылка"));
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("КоличествоЭкземпляров", 1);//не нужна структура вообще, здесь формируем по своему отдельно в вызове печати
	ПараметрыПечати.Вставить("СтруктураДанных", ДанныеП);
	ПараметрыПечати.Вставить("АдресВХранилище", "");
	ПараметрыПечати.Вставить("КаждаяЭтикеткаНаНовомЛисте", Истина);
	ПараметрыПечати.Вставить("СразуНаПринтер", Истина);
	ПараметрыПечати.Вставить("РежимПечати", "ЭтикеткаКодМаркировкиИСМП");  
	
	
	Если КонстантаПечататьСразуНаПринтер() Тогда
		Если ШаблонПечати = "Паллет" Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечатиНаПринтер("Обработка.ПечатьЭтикетокИЦенников", "ЭтикеткаКодМаркировкиИСМП", ПараметрКоманды, ПараметрыПечати);
			
		ИначеЕсли ШаблонПечати = "Короб" ИЛИ ШаблонПечати = "ШтрихкодМонопаллета" Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечатиНаПринтер("Обработка.ПечатьЭтикетокИЦенников","ЭтикеткаШтрихкодыУпаковки",ПараметрКоманды, ПолучитьПараметрыДляШтрихкодовУпаковок(ВладелецФормы.УникальныйИдентификатор,ВведенныйШтрихкод,ШаблонПечати));
			
		ИначеЕсли ШаблонПечати = "КИН" ИЛИ ШаблонПечати = "КМ" Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечатиНаПринтер("Обработка.ПечатьЭтикетокИЦенников", "ЭтикеткаКодМаркировкиИСМП", ПараметрКоманды, ПараметрыПечати);
			
		КонецЕсли;
	Иначе
		Если ШаблонПечати = "Паллет" Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьЭтикетокИЦенников","ЭтикеткаКодМаркировкиИСМП",ПараметрКоманды,ВладелецФормы,ПараметрыПечати);
			
		ИначеЕсли ШаблонПечати = "Короб" ИЛИ ШаблонПечати = "ШтрихкодМонопаллета" Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьЭтикетокИЦенников","ЭтикеткаШтрихкодыУпаковки",ПараметрКоманды, ВладелецФормы, ПолучитьПараметрыДляШтрихкодовУпаковок(ВладелецФормы.УникальныйИдентификатор,ВведенныйШтрихкод,ШаблонПечати));
			
		ИначеЕсли ШаблонПечати = "КИН" ИЛИ ШаблонПечати = "КМ" Тогда
			УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьЭтикетокИЦенников","ЭтикеткаКодМаркировкиИСМП",ПараметрКоманды,ВладелецФормы,ПараметрыПечати);
			
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыДляШтрихкодовУпаковок(ИдентификаторВладельца, ШККороба, ШаблонЭтикетки)
	
	ПараметрыПечати = Новый Структура;
	ШтрихкодыУпаковок = Новый ТаблицаЗначений;
	// Добавляем колонки
	ШтрихкодыУпаковок.Колонки.Добавить("ДатаМаркировки", Новый ОписаниеТипов("Дата"));
	ШтрихкодыУпаковок.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ШтрихкодыУпаковок.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("СправочникСсылка.ШтрихкодыУпаковокТоваров"));
	ШтрихкодыУпаковок.Колонки.Добавить("ТипШтрихкода", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыШтрихкодов"));
	ШтрихкодыУпаковок.Колонки.Добавить("Упаковка", Новый ОписаниеТипов("СправочникСсылка.ЕдиницыИзмерения"));
	ШтрихкодыУпаковок.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ШтрихкодыУпаковок.Колонки.Добавить("Штрихкод", Новый ОписаниеТипов("Строка"));

	// Создаем строку
	СтрокаТаблицы = ШтрихкодыУпаковок.Добавить();

	// Заполняем значения (имитация данных)
	СтрокаТаблицы["ДатаМаркировки"] = '00010101'; // Пустая дата
	СтрокаТаблицы["Номенклатура"] = "";//НоменклатураТекущая;//////////////////////////////////////////////////////////////////////////////////////////////////ХЗ
	СтрокаТаблицы["Ссылка"] = Справочники.ШтрихкодыУпаковокТоваров.НайтиПоРеквизиту("ЗначениеШтрихкода",ШККороба);
	СтрокаТаблицы["ТипШтрихкода"] = Перечисления.ТипыШтрихкодов.Code128;
	СтрокаТаблицы["Упаковка"] = Неопределено; // Пустая ссылка
	СтрокаТаблицы["Характеристика"] = Неопределено; // Пустая ссылка
	СтрокаТаблицы["Штрихкод"] = ШККороба;
	
	ПараметрыПечати.Вставить("ИсходныеДанные", ЗначениеВСтрокуВнутр(ШтрихкодыУпаковок));
	//ПараметрыПечати.Вставить("ИсходныеДанные", ЗначениеВСтрокуВнутр(ШтрихкодыУпаковок.Выгрузить()));
	ПараметрыПечати.Вставить("ШаблонЭтикетки",ПолучитьШаблонЭтикеткиНаСервере(ШаблонЭтикетки));
	ПараметрыПечати.Вставить("КоличествоЭкземпляров", 1);
	ПараметрыПечати.Вставить("СтруктураМакетаШаблона", Неопределено);
	ПараметрыПечати.Вставить("РежимПечати", "ЭтикеткаКодМаркировкиИСМП");
	
	Возврат ПараметрыПечати;
	
КонецФункции

&НаСервере
Функция КонстантаПечататьСразуНаПринтер()
	Возврат Константы.БИТ_ОтправкаПечатиКМКИНУШКсразуНаПринтер.Получить();
КонецФункции

&НаСервере
Функция ПоискУпаковкиПоШтрихкодуНаСервере(Знач ВведенныйШтрихкод)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ШтрихкодыУпаковокТоваров.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ШтрихкодыУпаковокТоваров КАК ШтрихкодыУпаковокТоваров
		|ГДЕ
		|	ШтрихкодыУпаковокТоваров.ЗначениеШтрихкода = &ЗначениеШтрихкода
		|	ИЛИ ШтрихкодыУпаковокТоваров.ЗначениеШтрихкода = &ЗначениеШтрихкодаУпаковки";
	
	Запрос.УстановитьПараметр("ЗначениеШтрихкода", ВведенныйШтрихкод);
	Запрос.УстановитьПараметр("ЗначениеШтрихкодаУпаковки", ВведенныйШтрихкод);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат "";
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции  

&НаСервере
Функция ПолучитьШаблонЭтикеткиНаСервере(ШаблонЭтикетки)
	
	// Ищем шаблон по имени или типу
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ХранилищеШаблонов.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ХранилищеШаблонов КАК ХранилищеШаблонов
		|ГДЕ
		|	ХранилищеШаблонов.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("Наименование", ШаблонЭтикетки);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	
	// Если не нашли, возвращаем пустую строку
	Возврат "";
	
КонецФункции

&НаКлиенте
Процедура ПовторнаяПечатьКМ(Команда)//код маркировки части набора или дойпака
	Если ТребуемыйКодМаркировки <> "" ИЛИ ТребуемыйКодМаркировки <> Неопределено Тогда
		//ПечатьКМ(ТребуемыйКодМаркировки);
	Иначе
		Сообщить("Еще не отсканирован Штрихкод дойпака!");
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПовторнаяПечатьКИНУ(Команда)//код маркировки набора
	Если Тип <> "Дойпак" Тогда//теперь нужно понять это часть набора или сам набор
		Если Тип ="Набор" Тогда
			//ПечатьКМ(ПолучитьМассивИзХранилища(МассивСвободныхШКУпакованныхКоробов)[0]);
		КонецЕсли;
		Если Тип = "ЧастьНабора" Тогда
			КодМаркировкиНабора = ПолучитьКодМаркировкиНабора(ПолучитьМассивИзХранилища(МассивСвободныхШКУпакованныхКоробов));
			Если КодМаркировкиНабора <> Неопределено Тогда
				//ПечатьКМ(КодМаркировкиНабора);
			Иначе
				Сообщить("Не найден КИНУ!");
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПолучитьКодМаркировкиНабора(МассивКМ)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УпаковкаПродукцииКодыМаркировки.ШтрихкодУпаковки КАК ШтрихкодУпаковки,
	               |	УпаковкаПродукцииКодыМаркировки.ДокументОснование КАК ДокументОснование,
	               |	УпаковкаПродукцииКодыМаркировки.НомерСтрокиВДокументеОсновании КАК НомерСтрокиВДокументеОсновании
	               |ИЗ
	               |	РегистрСведений.УпаковкаПродукцииКодыМаркировки КАК УпаковкаПродукцииКодыМаркировки
	               |ГДЕ
	               |	УпаковкаПродукцииКодыМаркировки.КодМаркировки В(&МассивКМ)";
	Запрос.УстановитьПараметр("МассивКМ",МассивКМ);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	УпаковкаПродукцииКодыМаркировки.КодМаркировки КАК КодМаркировки
		               |ИЗ
		               |	РегистрСведений.УпаковкаПродукцииКодыМаркировки КАК УпаковкаПродукцииКодыМаркировки
		               |ГДЕ
		               |	УпаковкаПродукцииКодыМаркировки.ШтрихкодУпаковки = &ШКУпаковки
		               |	И УпаковкаПродукцииКодыМаркировки.ДокументОснование = &ДокументОснование
		               |	И УпаковкаПродукцииКодыМаркировки.НомерСтрокиВДокументеОсновании = &НомерСтрокиВДокументеОсновании
		               |	И УпаковкаПродукцииКодыМаркировки.Тип = ""Набор""";
		Запрос.УстановитьПараметр("ШКУпаковки",Выборка.ШтрихкодУпаковки);
		Запрос.УстановитьПараметр("ДокументОснование",Выборка.ДокументОснование);
		Запрос.УстановитьПараметр("НомерСтрокиВДокументеОсновании",Выборка.НомерСтрокиВДокументеОсновании);
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		
		Если Выборка.Следующий() Тогда
			Возврат Выборка.КодМаркировки;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура ПроигратьЗвукОшибкиСканирования()
	//очищаем старое значение
	HTMLЗвук = "";
	//base64 преобразование звука
	Звук = "data:audio/mpeg;base64,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dBs5mzt0GbObP5mzGzlg2csGzFZs/mbObOZszdJYboKzZys2Y26TZ+mbObMWDZis2fywbP5WbN/+YkBL5kvCQGJAJCVkvlYkHmJAJAViQf/lYkP+EVAEVCBqFQAagUIGoVB4RUAMUMGKHwM0CQDEgkAzSJAYJAYJAiJbwYJQiJbgwSQiJIREsIiSHC4cIOEGVg3EHDg3GGVBuEOH/8MpDhBw//wygcL++n99NUxBTUUzLjEwMFVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVLAlIZeOXjn2rDgpjgg4KWAkMwkMJCLASEYlKcUGXjiUhiUolKZeMJSlgcFMJCCQjEpQkIyWccEP/++LEHAPl0SEOD9tVBCod4cH/dLgSkEpDCQxKUsF45jgolKZLMEhFgSkKwkIxwQSlMSlCQzEpCWcsBIhhIQlKYSEJSGhEksxhIYlKZxQEhgfBeCAaQuCAxIQMlKBpC4IBpCSEBpDlKByklKDJSAaQuCgaQpSAaQ5SAyUoRSGDOCgaQkhgxIQGkNIUDSGkIDSGkIDSHKQD4LKUIykA0hJDA0hpDCKQgNIcpANIaQ8GJD+Bq2Ka4RKaDCmf81y4r9n69n7X+fpca9eVriwu8rX+VrvLC7/KzIFM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";
	//записываем HTML
	HTMLЗвук = "<html><body><audio autoplay><source src='" + Звук + "' type='audio/mpeg'></audio></body></html>";
	
	//ВАРИАНТ 2
	//Звук = Новый COMОбъект("SAPI.SpVoice");
	//Голоса = Звук.GetVoices();
	//Для Индекс = 0 По Голоса.Count - 1 Цикл
	//    Если СтрНайти(Голоса.Item(Индекс).GetDescription(), "Male") > 0 Тогда //находим голос, у Дубровского на сервере их всего 2 на ОС
	//        Звук.Voice = Голоса.Item(Индекс);
	//        Прервать;
	//    КонецЕсли;
	//КонецЦикла;

	//// 2. Ускоряем речь (от -10 до 10, где 0 — норма)
	//Звук.Rate = 3;  // Можно поставить 5-7 для сильного ускорения
	//Звук.Volume = 100;  // Максимальная громкость
	//Звук.Speak("ТТТТТУУУУУУМММММ!"); // Голосовое оповещение
 КонецПроцедуры

