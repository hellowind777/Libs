--Cache global variables
local _G = _G
local date = date
local error = error
local pairs = pairs
local select = select
local tonumber = tonumber
local type = type
local unpack = unpack
local find, format, gmatch, gsub, len, lower, match, upper, sub = string.find, string.format, string.gmatch, string.gsub, string.len, string.lower, string.match, string.upper, string.sub
local getn = table.getn
--WoW API
local debugstack = debugstack
local GetContainerItemInfo = GetContainerItemInfo
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumSlots = GetContainerNumSlots
local GetInventoryItemTexture = GetInventoryItemTexture
local GetItemInfo = GetItemInfo
local GetQuestGreenRange = GetQuestGreenRange
local UnitLevel = UnitLevel
--WoW Variables
local NUM_BAG_FRAMES = NUM_BAG_FRAMES

CLASS_ICON_TCOORDS = {
	["WARRIOR"] = {0, 0.25, 0, 0.25},
	["MAGE"] = {0.25, 0.49609375, 0, 0.25},
	["ROGUE"] = {0.49609375, 0.7421875, 0, 0.25},
	["DRUID"] = {0.7421875, 0.98828125, 0, 0.25},
	["HUNTER"] = {0, 0.25, 0.25, 0.5},
	["SHAMAN"] = {0.25, 0.49609375, 0.25, 0.5},
	["PRIEST"] = {0.49609375, 0.7421875, 0.25, 0.5},
	["WARLOCK"] = {0.7421875, 0.98828125, 0.25, 0.5},
	["PALADIN"] = {0, 0.25, 0.5, 0.75}
}

--更新RAID_CLASS_COLORS表
local UpClassColor = CreateFrame("Frame", nil, UIParent)
UpClassColor:RegisterEvent("ADDON_LOADED")
local function UpdateColors()
	RAID_CLASS_COLORS = {
		["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, colorStr = "ffc79c6e" },
		["MAGE"]    = { r = 0.41, g = 0.8,  b = 0.94, colorStr = "ff69ccf0" },
		["ROGUE"]   = { r = 1,    g = 0.96, b = 0.41, colorStr = "fffff569" },
		["DRUID"]   = { r = 1,    g = 0.49, b = 0.04, colorStr = "ffff7d0a" },
		["HUNTER"]  = { r = 0.67, g = 0.83, b = 0.45, colorStr = "ffabd473" },
		["SHAMAN"]  = { r = 0.14, g = 0.35, b = 1.0,  colorStr = "ff0070de" },
		["PRIEST"]  = { r = 1,    g = 1,    b = 1,    colorStr = "ffffffff" },
		["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79, colorStr = "ff9482c9" },
		["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, colorStr = "fff58cba" },
	}

	RAID_CLASS_COLORS = setmetatable(RAID_CLASS_COLORS, { __index = function(tab,key)
		return { r = 0.6,  g = 0.6,  b = 0.6,  colorStr = "ff999999" }
	end})
end

UpClassColor:SetScript("OnEvent", function()
	UpdateColors()
end)

function HookScript(frame, scriptName, handler)
	if not (type(frame) == "table" and frame.GetScript and type(scriptName) == "string" and type(handler) == "function") then
		error("Usage: HookScript(frame, \"type\", function)", 2)
	end

	local original_scipt = frame:GetScript(scriptName)
	if original_scipt then
		frame:SetScript(scriptName, function()
			original_scipt(this)
			handler(this)
		end)
	else
		frame:SetScript(scriptName, handler)
	end
end

--用于界面UI框架的Hook
--举例HookAddonOrVariable("Blizzard_InspectUI", function() xxx end)
function HookAddonOrVariable(addon, func)
	local lurker = CreateFrame("Frame", nil)
	lurker.func = func
	lurker:RegisterEvent("ADDON_LOADED")
	lurker:RegisterEvent("VARIABLES_LOADED")
	lurker:RegisterEvent("PLAYER_ENTERING_WORLD")
	lurker:SetScript("OnEvent", function()
		-- only run when config is available
		if event == "ADDON_LOADED" and not this.foundConfig then
			return
		elseif event == "VARIABLES_LOADED" then
			this.foundConfig = true
		end

		if IsAddOnLoaded(addon) or _G[addon] then
			this:func()
			this:UnregisterAllEvents()
		end
	end)
end

function hooksecurefunc(arg1, arg2, arg3)
	local isMethod = type(arg1) == "table" and type(arg2) == "string" and type(arg1[arg2]) == "function" and type(arg3) == "function"
	if not (isMethod or (type(arg1) == "string" and type(_G[arg1]) == "function" and type(arg2) == "function")) then
		error("Usage: hooksecurefunc([table,] \"functionName\", hookfunc)", 2)
	end

	if not isMethod then
		arg1, arg2, arg3 = _G, arg1, arg2
	end

	local orig = arg1[arg2]
	arg1[arg2] = function(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20)
		local x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20 = orig(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20)
		
		arg3(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20)
		
		return x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20
	end
end

--框架开/关
function ToggleFrame(frame)
	if frame:IsShown() then
		HideUIPanel(frame)
	else
		ShowUIPanel(frame)
	end
end

--仇恨染色
local threatColors = {
	[0] = {0, 1, 0},
	[1] = {1, 1, 0},
	[2] = {1, 0.5, 0},
	[3] = {1, 0, 0}
}

function GetThreatStatusColor(statusIndex)
	if not (type(statusIndex) == "number" and statusIndex >= 0 and statusIndex < 4) then
		statusIndex = 0
	end

	return threatColors[statusIndex][1], threatColors[statusIndex][2], threatColors[statusIndex][3]
end

function GetThreatStatus(currentThreat, maxThreat)
	if type(currentThreat) ~= "number" or type(maxThreat) ~= "number" then
		error("Usage: GetThreatStatus(currentThreat, maxThreat)", 2)
	end

	if not currentThreat or currentThreat == nil then
		currentThreat = 0
	end

	if not maxThreat or maxThreat == 0 then
		currentThreat = 0
		maxThreat = 1
	end

	local threatPercent = currentThreat / maxThreat * 100
	if threatPercent > 100 then threatPercent = 100 end

	if threatPercent >= 90 then
		return 3, threatPercent
	elseif threatPercent >= 70 then
		return 2, threatPercent
	elseif threatPercent >= 50 then
		return 1, threatPercent
	else
		return 0, threatPercent
	end
end

--获取物品ID
function GetItemID(item)
	if type(item) == "number" then
		return item
	elseif type(item) == "string" then
		local _, _, id = string.find(item, "item:(%d+):%d+:%d+:%d+")
		if id then
			return tonumber(id)
		end
	end
end

function ItemLinkToName(link)
	if ( link ) then
		return gsub(link,"^.*%[(.*)%].*$","%1")
	end
end

--获取背包内物品信息
function FindItemInfo(item)
	if ( not item ) then return end
	item = lower(ItemLinkToName(item))
	local link
	for i = 1,23 do
		link = GetInventoryItemLink("player",i);
		if ( link ) then
			if ( item == string.lower(ItemLinkToName(link)) )then
				return i, nil, GetInventoryItemTexture('player', i), GetInventoryItemCount('player', i);
			end
		end
	end
	local bag, slot, texture
	local count = 0
	local totalcount = 0
	for i = 0, NUM_BAG_FRAMES do
		for j = 1, GetContainerNumSlots(i) do
			link = GetContainerItemLink(i,j)
			if ( link ) then
				if ( item == lower(ItemLinkToName(link))) then
					bag, slot = i, j
					texture, count = GetContainerItemInfo(i,j)
					totalcount = totalcount + count
				end
			end
		end
	end
	return bag, slot, texture, count, totalcount
end

--返回带词缀物品的ID
local LAST_ITEM_ID = 24283
local itemInfoDB = {}

function GetItemInfoByName(itemName)
	if type(itemName) ~= "string" then
		error("Usage: GetItemInfoByName(itemName)", 2)
	end

	if find(itemName, "之") then
		-- random enchantments
		itemName = gsub(itemName, "智力之", "")
		itemName = gsub(itemName, "力量之", "")
		itemName = gsub(itemName, "敏捷之", "")
		itemName = gsub(itemName, "耐力之", "")
		itemName = gsub(itemName, "精神之", "")
		itemName = gsub(itemName, "坚韧之", "")
		itemName = gsub(itemName, "优良之", "")
		itemName = gsub(itemName, "精通之", "")
		itemName = gsub(itemName, "防御之", "")
		itemName = gsub(itemName, "野兽杀手之", "")
		itemName = gsub(itemName, "报复之", "")
		itemName = gsub(itemName, "重击之", "")
		itemName = gsub(itemName, "测试之", "")
		itemName = gsub(itemName, "猎鹰之", "")
		itemName = gsub(itemName, "孤狼之", "")
		itemName = gsub(itemName, "灵猴之", "")
		itemName = gsub(itemName, "猛虎之", "")
		itemName = gsub(itemName, "夜枭之", "")
		itemName = gsub(itemName, "雄鹰之", "")
		itemName = gsub(itemName, "巨猿之", "")
		itemName = gsub(itemName, "巨鲸之", "")
		itemName = gsub(itemName, "野猪之", "")
		itemName = gsub(itemName, "野熊之", "")
		itemName = gsub(itemName, "奥术抗性之", "")
		itemName = gsub(itemName, "冰霜抗性之", "")
		itemName = gsub(itemName, "火焰抗性之", "")
		itemName = gsub(itemName, "暗影抗性之", "")
		itemName = gsub(itemName, "自然抗性之", "")
		itemName = gsub(itemName, "能量之", "")
		itemName = gsub(itemName, "格挡之", "")
		itemName = gsub(itemName, "精准之", "")
		itemName = gsub(itemName, "闪避之", "")
		itemName = gsub(itemName, "奥法惩戒之", "")
		itemName = gsub(itemName, "暗影惩戒之", "")
		itemName = gsub(itemName, "火焰惩戒之", "")
		itemName = gsub(itemName, "神圣惩戒之", "")
		itemName = gsub(itemName, "冰霜惩戒之", "")
		itemName = gsub(itemName, "自然惩戒之", "")
		itemName = gsub(itemName, "治疗之", "")
		itemName = gsub(itemName, "专注之", "")
		itemName = gsub(itemName, "再生之", "")
		itemName = gsub(itemName, "巫术之", "")
		itemName = gsub(itemName, "恢复之", "")
		itemName = gsub(itemName, "打击之", "")

	end

	if not itemInfoDB[itemName] then
		local name
		for itemID = 1, LAST_ITEM_ID do
			name = GetItemInfo(itemID)

			if name ~= nil and name ~= "" then
				itemInfoDB[name] = itemID

				if name == itemName then
					break
				end
			end
		end
	end

	if not itemInfoDB[itemName] then return end

	return GetItemInfo(itemInfoDB[itemName])
end

--新增
-- [ GetSpellMaxRank ]
-- Returns the maximum rank of a players spell.
-- "name"       [string]            spellname to query
-- return:      [string],[number]   maximum rank in characters and the number
--                                  e.g "Rank 1" and "1"
local spellmaxrank = {}
function GetSpellMaxRank(name)
	local cache = spellmaxrank[name]
	if cache then return cache[1], cache[2] end

	local rank = { 0, nil }

	for j = 1, 2 do
		local bookType = j == 1 and BOOKTYPE_SPELL or BOOKTYPE_PET
		local numTabs = GetNumSpellTabs() -- 只调用一次并存储结果
		for i = 1, numTabs do
			local _, _, offset, num = GetSpellTabInfo(i)
			for id = offset + 1, offset + num do
				local spellName, spellRank = GetSpellName(id, bookType)
				if name == spellName then
					if not rank[2] then rank[2] = spellRank end

					local _, _, numRank = string.find(spellRank, " (%d+)$")
					if numRank and tonumber(numRank) > rank[1] then
						rank = { tonumber(numRank), spellRank }
					end
				end
			end
		end
	end

	spellmaxrank[name] = { rank[2], rank[1] }
	return rank[2], rank[1]
end

-- [ GetSpellIndex ]
-- Returns the spellbook index and bookid of the given spell.
-- "name"       [string]            spellname to query
-- "rank"       [string]            rank to query (optional)
-- return:      [number],[string]   spell index and spellbook id
local spellindex = {}
function GetSpellIndex(name, rank)
	local cache = spellindex[name .. (rank and ("(" .. rank .. ")") or "")]
	if cache then return cache[1], cache[2] end

	if not rank then rank = GetSpellMaxRank(name) end

	for j = 1, 2 do
		local bookType = j == 1 and BOOKTYPE_SPELL or BOOKTYPE_PET
		local numTabs = GetNumSpellTabs() -- 只调用一次并存储结果
		for i = 1, numTabs do
			local _, _, offset, num = GetSpellTabInfo(i)
			for id = offset + 1, offset + num do
				local spellName, spellRank = GetSpellName(id, bookType)
				if rank and rank == spellRank and name == spellName then
					spellindex[name .. "(" .. rank .. ")"] = { id, bookType }
					return id, bookType
				elseif not rank and name == spellName then
					spellindex[name] = { id, bookType }
					return id, bookType
				end
			end
		end
	end

	spellindex[name .. (rank and ("(" .. rank .. ")") or "")] = { nil }
	return nil
end

-- [ GetSpellInfo ]
-- Returns several information about a spell.
-- "index"      [string/number]     Spellname or Index of a spell in the spellbook
-- "bookType"   [string]            Type of spellbook (optional)
-- return:
--              [string]            Name of the spell
--              [string]            Secondary text associated with the spell
--                                  (e.g."Rank 5", "Racial", etc.)
--              [string]            Path to an icon texture for the spell
--              [number]            Casting time of the spell in milliseconds
--              [number]            Minimum range from the target required to cast the spell
--              [number]            Maximum range from the target at which you can cast the spell
local spellinfo = {}
function GetSpellInfo(index, bookType)
	local cache = spellinfo[index]
	if cache then return cache[1], cache[2], cache[3] end

	local name, rank, id
	local icon = ""

	if type(index) == "string" then
		local _, _, sname, srank = find(index, "(.+)%((.+)%)")
		name = sname or index
		rank = srank or GetSpellMaxRank(name)
		id, bookType = GetSpellIndex(name, rank)

		-- correct name in case of wrong upper/lower cases
		if id and bookType then
			name = GetSpellName(id, bookType)
		end
	else
		name, rank = GetSpellName(index, bookType)
		id, bookType = GetSpellIndex(name, rank)
	end

	if name and id then
		icon = GetSpellTexture(id, bookType)
	end

	spellinfo[index] = { name, rank, icon }
	return name, rank, icon
end

-- Reset all spell caches whenever new spells are learned/unlearned
local resetcache = CreateFrame("Frame")
resetcache:RegisterEvent("LEARNED_SPELL_IN_TAB")
resetcache:RegisterEvent("SPELLS_CHANGED")
resetcache:SetScript("OnEvent", function()
	spellmaxrank, spellindex, spellinfo = {}, {}, {}
end)

-- [ 延迟函数 ]
-- 将函数添加到FIFO（先进先出）队列，以便在短暂延迟后执行。
-- "..."        [vararg]        function, [arguments]
local timer
function QueueFunction(a1, a2, a3, a4, a5, a6, a7, a8, a9)
	if not timer then
		timer = CreateFrame("Frame")
		timer.queue = {}
		timer.interval = TOOLTIP_UPDATE_TIME
		timer.DeQueue = function()
			local item = table.remove(timer.queue, 1)
			if item then
				item[1](item[2], item[3], item[4], item[5], item[6], item[7], item[8], item[9])
			end
			if table.getn(timer.queue) == 0 then
				timer:Hide() -- no need to run the OnUpdate when the queue is empty
			end
		end
		timer:SetScript("OnUpdate", function()
			this.sinceLast = (this.sinceLast or 0) + arg1
			while (this.sinceLast > this.interval) do
				this.DeQueue()
				this.sinceLast = this.sinceLast - this.interval
			end
		end)
	end
	table.insert(timer.queue, { a1, a2, a3, a4, a5, a6, a7, a8, a9 })
	timer:Show() -- start the OnUpdate
end

--单位颜色
function UnitColor(unit)
	local r, g, b

	if UnitIsPlayer(unit) then
		local color = RAID_CLASS_COLORS[select(2, UnitClass(unit))]
		if color then r, g, b = color.r, color.g, color.b end
	elseif UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
		r = 0.5
		g = 0.5
		b = 0.5
	else
		local color = UnitReactionColor[UnitReaction(unit, "player")]
		if color then r, g, b = color.r, color.g, color.b end
	end

	return r, g, b
end

UnitHealthBarColor = UnitColor -- (凡人版EN_UnitFrames单位颜色，插件需调用)

--百分比颜色
function SetPercentColor(min, max)
	local r = 0
	local g = 1
	local b = 0
	if (min and max) then
		local v = tonumber(min) / tonumber(max)
		if (v >= 0 and v <= 1) then
			if (v > 0.2) then
				r = (1.0 - v) * 2
				g = v * 2
			else
				r = 1.0
				g = 0
			end
		end
	end
	if r < 0 then
		r = 0
	elseif r > 1 then
		r = 1
	end
	if g < 0 then
		g = 0
	elseif g > 1 then
		g = 1
	end

	return r, g, b
end

--以"万"显示计数
function Over1E3toK(v)
	local sign = v < 0 and -1 or 1
	v = math.abs(v)

	if v > 1E4 then
		text = Round(v / 1E4 * sign, 1) .. "万"
	else
		text = Round(v)
	end
	return text
end

--渐隐按钮
function EnableAutohide(frame, timeout)
	if not frame then return end

	frame.hover = frame.hover or CreateFrame("Frame", frame:GetName() .. "Autohide", frame)
	frame.hover:SetParent(frame)
	frame.hover:SetAllPoints(frame)
	frame.hover.parent = frame
	frame.hover:Show()

	local timeout = timeout
	frame.hover:SetScript("OnUpdate", function()
		if MouseIsOver(this, 50, -50, -50, 50) then
			this.activeTo = GetTime() + timeout
			this.parent:SetAlpha(1)
		elseif this.activeTo then
			if this.activeTo < GetTime() and this.parent:GetAlpha() > 0 then
				this.parent:SetAlpha(this.parent:GetAlpha() - 0.1)
			end
		else
			this.activeTo = GetTime() + timeout
		end
	end)
end

-- 光环时间替换
function SecondsToTimeAbbrev(time, f)
	local h, m, s, text
	if time <= 0 then
		text = ""
	elseif time < 3600 and time > 60 then
		h = floor(time / 3600)
		m = (f ~= nil) and floor(mod(time, 3600) / 60) or floor(mod(time, 3600) / 60 + 1)
		s = mod(time, 60)
		text = (f ~= nil) and format("|cffffffff%d|r:|cffffffff%02d|r", m, s) or format("|cffffffff%d|rm", m)
	elseif 1 < time and time < 60 then
		m = floor(time / 60)
		s = mod(time, 60)
		text = m == 0 and format("|cffffffff%d|rs", s)
	elseif time < 1 then
		s = mod(time, 60)
		text = format("|cffff0000%.1f|r", Round(s, 1))
	else
		h = floor(time / 3600 + 1)
		text = format("|cffffffff%d|rh", h)
	end
	return text
end

-- 定义自定义函数 SetSize
function SetSize(f, w, h)
	if not f then return end
	f:SetWidth(w)
	f:SetHeight(h)
end
