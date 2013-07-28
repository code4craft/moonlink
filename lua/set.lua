--
-- User: code4crafter@gmail.com
-- Date: 13-7-28
-- Time: 下午12:15
--
-- lua redis module https://github.com/agentzh/lua-resty-redis
-- http luad module http://wiki.nginx.org/HttpLuaModule

local redis = require"resty.redis"
local red = redis:new()
local server = "127.0.0.1"
local host = "http://127.0.0.1:8080/"

--connect
red:set_timeout(1000) -- 1 sec
local ok, err = red:connect(server, 6379)
if not ok then
    ngx.log(ngx.INFO, "failed to connect: ", err)
    ngx.say("failed to connect: ", err)
    return
end

--ngx.log(ngx.req.get_uri_args())
--ngx.say(ngx.req.get_uri_args(1))

length = 7

function short(url)
    local shortUrl = ngx.md5(url):sub(1, length)
    return shortUrl
end

local args = ngx.req.get_uri_args()
if not args["url"] then
    ngx.status = 400
    ngx.say("Please specific url!")
    return
end

local url = args["url"]
if not url:match("^http[s]?://") then
    ngx.status = 400
    ngx.say("Unsupport url!")
    return
end

local shortUrl
local tempUrl = url
while not shortUrl do
    shortUrl = short(tempUrl)
    local res, err = red:get(shortUrl)
    if res==ngx.null then
        red:set(shortUrl, url)
        break
    elseif res==url then
        break
    end
    tempUrl = tempUrl .. "X"
    shortUrl = nil
end

ngx.status = 200
ngx.say(host..shortUrl)

-- keepalive
local ok, err = red:set_keepalive(0, 100)
if ok then
    ngx.log(ngx.INFO, "Sucessfully keepalive", err)
else
    ngx.log(ngx.ERR, "Failed to keepalive", err)
end