# Easy Lotto (web)

**Stack:**

* Ruby 2.4.1
* Rails 5.1.1


### Rails commands

**Model creation**

```
$ rails g model Lottery name:string
$ rails g model Draw lottery:references:index number:integer date:date numbers:text prizes:text
```

**Misc**

```
$ rails db:seed
$ rails 'importer:lotofacil[10]'
$ RAILS_ENV=production rails db:migrate
$ RAILS_ENV=production rails db:seed
$ RAILS_ENV=production rails 'importer:lotofacil[5]'
```
