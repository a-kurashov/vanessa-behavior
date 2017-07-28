﻿
///////////////////////////////////////////////////
//Служебные функции и процедуры
///////////////////////////////////////////////////

&НаКлиенте
// контекст фреймворка Vanessa-Behavior
Перем Ванесса;
 
&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;
 
&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-Behavior.
Перем КонтекстСохраняемый Экспорт;

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;
	
	ВсеТесты = Новый Массив;

	//описание параметров
	//Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,ОписаниеШага,ТипШага,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ТабличныйДокументСоответствуетМакету(Парам01,Парам02)","ТабличныйДокументСоответствуетМакету","И табличный документ ""ТабДок"" соответствует макету ""Макет1""","Сравнивает значения макета с эталоном. Макет ищется сначала в обработке фича файла, затем в каталоге проекта.","UI.Табличный документ.Проверка значения");

	Возврат ВсеТесты;
КонецФункции
	
&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции
	
&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции



///////////////////////////////////////////////////
//Работа со сценариями
///////////////////////////////////////////////////

&НаКлиенте
// Процедура выполняется перед началом каждого сценария
Процедура ПередНачаломСценария() Экспорт
	
КонецПроцедуры

&НаКлиенте
// Процедура выполняется перед окончанием каждого сценария
Процедура ПередОкончаниемСценария() Экспорт
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТабличныйДокументНаСервере(АдресВременногоХранилища)
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("mxl");
	ДвоичныеДанные.Записать(ИмяВременногоФайла);
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Прочитать(ИмяВременногоФайла);
	УдалитьФайлы(ИмяВременногоФайла);
	Возврат ТабличныйДокумент;
КонецФункции


///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//И табличный документ "ТабДок" соответствует макету "Макет1"
//@ТабличныйДокументСоответствуетМакету(Парам01,Парам02)
Процедура ТабличныйДокументСоответствуетМакету(ИмяРеквизита,ИмяМакета) Экспорт
	Макет = Ванесса.ПолучитьМакетОбработки("ИмяМакета");
	
	Если Макет = Неопределено Тогда
		//будем искать макет в каталоге проекта
		
		Если НЕ ЗначениеЗаполнено(Ванесса.Объект.КаталогПроекта) Тогда
			ВызватьИсключение "Не найден эталон макета <" + ИмяМакета + ">. Пустой каталог проекта.";
		КонецЕсли;	 
		
		Нашли = Ложь;
		
		ИмяФайла = Ванесса.Объект.КаталогПроекта + "\Макеты\" + ИмяМакета + ".mxl";
		Если Ванесса.ФайлСуществуетКомандаСистемы(ИмяФайла) Тогда
			Нашли = Истина;
		КонецЕсли;	 
		
		Если Не Нашли Тогда
			ИмяФайла = Ванесса.Объект.КаталогПроекта + "\" + ИмяМакета + ".mxl";
			Если Ванесса.ФайлСуществуетКомандаСистемы(ИмяФайла) Тогда
				Нашли = Истина;
			КонецЕсли;	 
		КонецЕсли;	 
		
		Если Не Нашли Тогда
			ВызватьИсключение "Не найден файл макета <" + ИмяМакета + "> в каталоге проекта <" + Ванесса.Объект.КаталогПроекта + ">";
		КонецЕсли;	 
		
		ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
		АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
		ТабДокБыло = ПолучитьТабличныйДокументНаСервере(АдресВременногоХранилища);
	Иначе
		ТабДокБыло = Макет;
	КонецЕсли;	 
	
	
	ПолеТабличногоДокумента   = Ванесса.НайтиРеквизитОткрытойФормыПоЗаголовку(ИмяРеквизита,Истина);
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("mxl");
	КонтекстСохраняемый.ТестовоеПриложение.УстановитьРезультатДиалогаВыбораФайла(Истина, ИмяВременногоФайла);
	ПолеТабличногоДокумента.ЗаписатьСодержимоеВФайл();
	КонтекстСохраняемый.ТестовоеПриложение.ОжидатьОтображениеОбъекта(,,, 10);
	Если Не Ванесса.ФайлСуществуетКомандаСистемы(ИмяВременногоФайла) Тогда
		ВызватьИсключение("Не обнаружен файл " + ИмяВременногоФайла);
	КонецЕсли;
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	
	ТабДокСтало = ПолучитьТабличныйДокументНаСервере(АдресВременногоХранилища);
	
	Ванесса.УдалитьФайлыКомандаСистемы(ИмяВременногоФайла);
	
	Ванесса.ПроверитьРавенствоТабличныхДокументовТолькоПоЗначениям(ТабДокБыло, ТабДокСтало);
КонецПроцедуры
