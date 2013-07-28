--
-- User: code4crafter@gmail.com
-- Date: 13-7-28
-- Time: 下午12:15
--
-- lua redis module https://github.com/agentzh/lua-resty-redis
-- http luad module http://wiki.nginx.org/HttpLuaModule

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

--ngx.log(ngx.req.get_uri_args())
--ngx.say(ngx.req.get_uri_args(1))

length=7

function short(url)
    local shortUrl = string.sub(ngx.md5(url), 0, length)
    return shortUrl
end

local args = ngx.req.get_uri_args()
if not args["url"] then
    ngx.say("Please specific url!")
    return
end

local url=args["url"]
if not string.match(url,"^http[s]?://") then
    ngx.say("Unsupport url!")
    return
end

local shortUrl = short(url)

ngx.say(shortUrl)

-- keepalive
local ok,err = red:set_keepalive(0,100)
if  ok then
    ngx.log(ngx.INFO,"Sucessfully keepalive",err)
else
    ngx.log(ngx.ERR,"Failed to keepalive",err)
end
