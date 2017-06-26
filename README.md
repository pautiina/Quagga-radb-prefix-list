# Quagga-radb-prefix-list
Скрипт позволяет обновлять prefix-list на маршрутизаторах с установленной Quagga по RADB

Настройка скрипта очень проста.
В файле OBJECTS-FOR-PREFIX-LIST, который должен располагатся в директории со скриптом, необходимо укзать информацию по чем строить PREFIX-LIST, название PREFIX-LIST в QUAGGA и по желанию description PREFIX-LIST  

В **`crontab`** необходимо добавить задание с укзанием времени, когда Вы хотите, что-бы обновлялись префикс листы.

`00      03      *       *       *       root    /PATH_TO_SCRIPT/quagga_prefix_build.sh`

