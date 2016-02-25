# Helock

Helock is personal alarm clock worker running on heroku.  
Every mornig, helock sends direct message to us.

[@helock_bot](https://twitter.com/helock_bot) < Good Morning !


## Settings

```
% git clone https://github.com/grauwoelfchen/helock.git
% cd helock
% bundle install --path .bundle/gems
% mv {.env.sample,.env}
```

### ENV

Edit [.env.sample](https://github.com/grauwoelfchen/helock/blob/master/.env.sample)

### messages.yaml

```
---
- ['Sunday :-D']
- ['Monday :-(']
- [
    'Good Morning!',
    'Wake up!',
  ]
...
```

### users.yaml

```
---
- 'grauwoelfchen'
- 'you'
```


## Usage

```
% bundle exec foreman run clock
```


## License

Copyright (C) 2011 - 2016 Yasuhiro Asaka  \<grauwoelfchen@gmail.com\>  
[MIT License](https://github.com/grauwoelfchen/helock/blob/master/LICENSE)
