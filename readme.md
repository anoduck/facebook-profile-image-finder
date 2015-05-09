# Quick & dirty Facebook image finder with threading

### Why?
We needed a quick way to suggest potential brand logos to our users at Leaply. A friend (https://twitter.com/hypn) suggested I do it with Facebook. This is the end result.

###How?
Easy!
```ruby
fbl = FacebookLogos.new(access_token: 'a8YISniwpvDSDjD7Cx1hCyHSj44ICPaKPTxZCz...')
logos = fbl.find_logos('bmw south africa')
```

###Urgh!

This is a dirty chunk of code - if you'd like to improve it, please send a PR. :)