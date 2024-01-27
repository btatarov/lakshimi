-- hello world
print('Hello, 世界')

-- json test
json = [[
{
    "name": "Lakshmi",
    "version": 0.1,
    "build": 1,
    "development": true,
    "released": false,
    "keywords": [
        "engine",
        "odin",
        "lua"
    ],
    "contributors": {
        "main": "Bogdan Tatarov"
    }
}
]]

data = LakshmiJSON.decode(json)
print(data.name)
print(data.version)
print(data.build)
for i, v in ipairs(data.keywords) do
    print(i, v)
end
for k, v in pairs(data.contributors) do
    print(k, v)
end

json = LakshmiJSON.encode(data)
print(json)

-- window test
LakshmiWindow.open('Lakshmi', 1024, 768)

-- sprite/renderer test
sprite1 = LakshmiSprite.new('test/lakshmi.png')
LakshmiRenderer.add(sprite1)

sprite2 = LakshmiSprite.new('test/lakshmi.png')
sprite2:setPos(1, 1)
LakshmiRenderer.add(sprite2)
