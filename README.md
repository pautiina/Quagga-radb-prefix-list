# Quagga-radb-prefix-list
Скрипт позволяет обновлять **`prefix-list`** на маршрутизаторах с установленной **Quagga** по **RADB**.

Скрипт использует установленный с портов или pkg утилиту - **`bgpq3`**

## Настройка
В файле `OBJECTS-FOR-PREFIX-LIST`, который должен располагатся в директории со скриптом, необходимо укзать все в одну строку:
- AS Macro (RADB) - `as-set` или `as-num`
- Quagga `prefix-list` name 
- Quagga `prefix-list` desciption 

Выставить права на файл `quagga_prefix_build.sh`: **544**

В **`crontab`** необходимо добавить задание с укзанием времени, когда Вы хотите, что-бы обновлялись префикс листы.

`00      03      *       *       *       root    /PATH_TO_SCRIPT/quagga_prefix_build.sh`

