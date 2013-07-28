--
-- User: code4crafter@gmail.com
-- Date: 13-7-28
-- Time: 下午12:31
--

local redis = require "resty.redis"
local red = redis:new()
local server = "127.0.0.1"

--connect
red:set_timeout(1000) -- 1 sec
local ok, err = red:connect(server, 6379)
if not ok then
    ngx.log(ngx.INFO,"failed to connect: ",err)
    ngx.say("failed to connect: ",err)
    return
end

local args = ngx.req.get_uri_args()
local short = args["short"]
if not short then
    ngx.status = 400
    ngx.say("Please specific url!")
    return
end

local res, err = red:get(short)
ngx.log(ngx.INFO, short)
if res == ngx.null then
    ngx.status = 404
    ngx.say("Url not exist!")
else
    ngx.say(res)
end

-- keepalive
local ok,err = red:set_keepalive(0,100)
if  ok then
    ngx.log(ngx.INFO,"Sucessfully keepalive",err)
else
    ngx.log(ngx.ERR,"Failed to keepalive",err)
end
