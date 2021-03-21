
![Dentiio Student  Api](https://www.dentiio.com/img/logoblue.png)

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
----------------

[Dentiio Student](https://www.dentiio.com/)  Api is an [API Platefom](https://github.com/api-platform/api-platform)


----------------

### Principal contributors :  
[Lory][L]
,[Arthur][A]
,[Romain][R] 
& [Mounia][M]

[L]:https://github.com/loryleticee
[R]:https://github.com/romainmaucot
[A]:https://github.com/adjikpo
[M]:https://github.com/lyafmounia

----------------

## 📋 Requirements
- 🛠Make
- :elephant: PHP-fpm >= 8 
- MariaDB = 10.5
- NGINX >= 1.13.6
- Composer = 2.0.8
- 🐳Docker

## 🎉 Building your app

### with docker
1. Launch the command  `make help` or `make` generate list of targets with descriptions
2. Build the docker and project environment
```bash
$ make env 
```
- add your port on the docker-compose.override.yml
- add the name database & password root on .env.docker
- add the name, password & name database on .env.local(src/.env.local)
3. Build the docker & the app
``` bash

$ make install
$ make composer
$ make database-init
```

or

``` bash

$ make all
```