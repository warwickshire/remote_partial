
RemotePartial.define(
  url: 'http://www.timeanddate.com/worldclock/city.html?n=136',
  name: 'clock',
  criteria: '#ct',
  minimum_life: 5.minutes
)

RemotePartial.define(
  url: 'http://www.ruby-lang.org/en/',
  name: 'ruby',
  criteria: '#intro',
  minimum_life: 3.hours
)
  

