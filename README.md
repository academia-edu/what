What? A simple server monitoring tool.
======================================

What is a modular, easily-extensible server monitoring tool which is still in
the early stages of development.

### What do I install?

    $ gem install what

### What does it do?

Right now, the example config file monitors Unicorn workers. Observe:

    $ what -c example/what.yml >/dev/null 2>&1 &
    [1] 2392
    $ curl localhost:9428
    {"unicorn":{"details":[{"cpu_time":"0:00.02","pid":"11023"},{"cpu_time":"0:00.02","pid":"11022"}],"health":"ok","workers":2},"health":"ok"}
    $ sudo /etc/init.d/unicorn stop
    $ curl localhost:9428
    {"unicorn":{"details":[],"health":"alert","workers":0},"health":"alert"}

When the health value of any module is set to "alert" instead of "ok",
the HTTP request returns 503 instead of 200. This means What can easily
be used in conjunction with monitoring tools like Pingdom.

Writing monitoring modules is easy: the only requirement is that they
implement a `health` method, which returns `:ok`, `:warning`, or `:alert`.
They can also implement a `details` method, which returns the hash
that's included in the HTTP response. See the included `What::Modules::Base`
and `What::Modules::Unicorn` classes for the implementation details.

### What's the plan?

Eventually, it should be possible to write a What module which monitors other
What servers across an entire deployment, pulling together all relevant
information into one JSON object.