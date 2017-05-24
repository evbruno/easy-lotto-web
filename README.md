# Easy Lotto (web)

**Stack:**

* Ruby 2.4.1
* Rails 5.1.1


### Rails commands

**Model creation**

```
$ rails g model Lottery name:string
$ rails g model Draw lottery:references:index number:integer date:date numbers:text prizes:text

$ rails g model User name:string email:string:index avatar:string
$ rails g model Group name:string
$ rails g model UserGroup user:references:index group:references:index admin:boolean balance:float
$ rails g model UserBalanceEntry user_group:references:index value:float date:date approved:boolean

$ rails g model BettingPool date:date group:references:index
$ rails g model LotteryBet betting_pool:references:index sequence:integer numbers:text lottery:references:index first_draw:integer last_draw:integer
```

**Misc**

```
$ rails db:seed
$ rails 'importer:lotofacil[10]'
$ RAILS_ENV=production rails db:migrate
$ RAILS_ENV=production rails db:seed
$ RAILS_ENV=production rails 'importer:lotofacil[5]'
```

## Other commands

### Docker: MySQL

```
$ docker run --name some-mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=mypass -d mysql:5.7.17
$ docker exec -it some-mysql /bin/bash
$ mysql -uroot -pmypass
$ create database easy_lotto_dev
```

### Docker: PostgreSQL and Rails

```
$ docker build . --tag trusty-local-dev

# run fg
$ docker run --rm --name some-trusty -p 5432:5432 -p 3000:3000 -v "$(pwd):/webapp" trusty-local-dev

# run bg
$ docker run --name some-trusty -p 5432:5432 -p 3000:3000 -v "$(pwd):/webapp" -d trusty-local-dev
$ docker logs -f some-trusty

$ docker exec -it some-trusty /bin/bash
$ cd /webapp
$ bundle install
$ rails s
```
