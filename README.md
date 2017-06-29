# Quagga-radb-prefix-list
Скрипт позволяет обновлять **`prefix-list`** на маршрутизаторах с установленной **Quagga** по **RADB**.

Скрипт использует установленный с портов или pkg утилиту - **`bgpq3`**

## Настройка
Все настройки задаются в файле `OBJECTS-FOR-PREFIX-LIST`.

Параметры для каждого `prefix-list` должны начинатся с новой строки, также допускаются комментарии через `#`.

Параметры для `prefix-list` задаются в одну строку:

      AS-Macro NAME DESCRIPTION

- AS-Macro (RADB) - `as-set` или `as-num` **(обязательный параметр)**
- Quagga `prefix-list` name **(обязательный параметр)**
- Quagga `prefix-list` desciption 

Выставить права на файл `quagga_prefix_build.sh`: **544**

В **`crontab`** необходимо добавить задание с укзанием времени, когда Вы хотите, что-бы обновлялись префикс листы.

`00		 03		 *		 *		 *		 root	 /PATH_TO_SCRIPT/quagga_prefix_build.sh`
