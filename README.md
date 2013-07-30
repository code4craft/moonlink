moonlink
========

> A short url service based on OpenResty and redis.

### Get started

Download and install [**OpenResty**](http://openresty.org/)。

Download and install [**redis**](http://redis.io/)。

start redis:

	redis-server

start nginx:

	nginx -p /path/of/moonlink -c conf/moonlink.conf 

### Performance

Intel i5 core*4 4G RAM

	ab -n100000 -c100 -r http://127.0.0.1:8080/c9613a
	Requests per second:    8896.09 [#/sec] (mean)
	Time per request:       11.241 [ms] (mean)
	Time per request:       0.112 [ms] (mean, across all concurrent requests)