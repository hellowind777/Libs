if AceLibrary:HasInstance("ItemBonusLib-1.0") then return end

local L = AceLibrary("AceLocale-2.2"):new("ItemBonusLib")

L:RegisterTranslations("zhCN", function () return {
	--CHAT_COMMANDS = { "/abonus" },
	-- ["An addon to get information about bonus from equipped items"] = true,
	-- ["show"] = true,
	-- ["Show all bonuses from the current equipment"] = true,
	-- ["Current equipment bonuses:"] = true,
	-- ["details"] = true,
	-- ["Shows bonuses with slot distribution"] = true,
	-- ["Current equipment bonus details:"] = true,
	-- ["item"] = true,
	-- ["show bonuses of given itemlink"] = true,
	-- ["<itemlink>"] = true,
	-- ["Bonuses for %s:"] = true,
	-- ["Item is part of set [%s]"] = true,
	-- [" %sBonus for %d pieces :"] = true,
	-- ["slot"] = true,
	-- ["show bonuses of given slot"] = true,
	-- ["<slotname>"] = true,
	-- ["Bonuses of slot %s:"] = true,
	
	-- bonus names
	NAMES = {	
		STR 		= "力量",
		AGI 		= "敏捷",
		STA 		= "耐力",
		INT 		= "智力",
		SPI 		= "精神",
		ARMOR 		= "强化护甲",

		ARCANERES 	= "奥术抗性",	
		FIRERES 	= "火焰抗性",
		NATURERES 	= "自然抗性",
		FROSTRES 	= "冰霜抗性",
		SHADOWRES 	= "暗影抗性",

		FISHING 	= "钓鱼",
		MINING 		= "挖矿",
		HERBALISM 	= "草药",
		SKINNING 	= "剥皮",
		DEFENSE 	= "防御技能",
		
		BLOCK 		= "格挡几率",
		BLOCKVALUE  = "格挡值",
		DODGE 		= "躲闪",
		PARRY 		= "招架",
		ATTACKPOWER = "攻击强度",
		ATTACKPOWERUNDEAD = "对亡灵攻击强度",
		ATTACKPOWERFERAL = "对野兽攻击强度",
		CRIT 		= "致命",
		RANGEDATTACKPOWER = "远程攻击强度",
		RANGEDCRIT 	= "远程攻击致命",
		TOHIT 		= "命中率",

		DMG 		= "法术伤害",
		DMGUNDEAD	= "对亡灵法术伤害",
		ARCANEDMG 	= "奥术伤害",
		FIREDMG 	= "火焰伤害",
		FROSTDMG 	= "冰霜伤害",
		HOLYDMG 	= "神圣伤害",
		NATUREDMG 	= "自然伤害",
		SHADOWDMG 	= "暗影伤害",
		SPELLCRIT 	= "法术致命",
		SPELLTOHIT 	= "法术命中率",
		SPELLPEN 	= "降低目标抗性",
		HEAL 		= "治疗",
		HOLYCRIT 	= "神圣法术致命",

		HEALTHREG 	= "生命恢复",
		MANAREG 	= "法力恢复",
		HEALTH 		= "生命值",
		MANA 		= "法力值"
	};


	-- passive bonus patterns. checked against lines which start with above prefixes
	PATTERNS_PASSIVE = {
		{ pattern = "+(%d+)远程攻击强度。", effect = "RANGEDATTACKPOWER" },
		{ pattern = "使你用盾牌格挡攻击的几率提高(%d+)%%。", effect = "BLOCK" },
		{ pattern = "使你的盾牌的格挡值提高(%d+)点。", effect = "BLOCKVALUE" },
		{ pattern = "使你躲闪攻击的几率提高(%d+)%%。", effect = "DODGE" },
		{ pattern = "使你招架攻击的几率提高(%d+)%%。", effect = "PARRY" },
		{ pattern = "使你的法术造成致命一击的几率提高(%d+)%%。", effect = "SPELLCRIT" },
		{ pattern = "使你的神圣法术造成致命一击的几率提高(%d+)%%。", effect = "HOLYCRIT" },
		{ pattern = "使你的神圣系法术的致命一击和极效治疗几率提高(%d+)%%。", effect = "HOLYCRIT" },
		{ pattern = "使你造成致命一击的几率提高(%d+)%%。",	effect = "CRIT" },
		{ pattern = "使你打出致命一击的几率提高(%d+)%%。",	effect = "CRIT" },
		{ pattern = "使你的远程武器造成致命一击的几率提高(%d+)%%。", effect = "RANGEDCRIT" },
		{ pattern = "提高奥术法术和效果所造成的伤害，最多(%d+)点。", effect = "ARCANEDMG" },
		{ pattern = "提高火焰法术和效果所造成的伤害，最多(%d+)点。", effect = "FIREDMG" },
		{ pattern = "提高冰霜法术和效果所造成的伤害，最多(%d+)点。", effect = "FROSTDMG" },
		{ pattern = "提高神圣法术和效果所造成的伤害，最多(%d+)点。", effect = "HOLYDMG" },
		{ pattern = "提高自然法术和效果所造成的伤害，最多(%d+)点。", effect = "NATUREDMG" },
		{ pattern = "提高暗影法术和效果所造成的伤害，最多(%d+)点。", effect = "SHADOWDMG" },
		{ pattern = "使治疗法术和效果所回复的生命值提高(%d+)点。", effect = "HEAL" },
		{ pattern = "提高法术所造成的治疗效果，最多(%d+)点。", effect = "HEAL" },
		{ pattern = "提高法术和魔法效果所造成的治疗效果，最多(%d+)点。", effect = "HEAL"}, -- thanks marshall_c@mop
		{ pattern = "使法术的治疗效果提高最多(%d+)点。", effect = "HEAL" }, 	-- thanks kkk36@mop
		{ pattern = "[提]*高所有法术和魔法效果所造成的伤害和治疗效果，最多(%d+)点。", effect = {"HEAL", "DMG"} },
		{ pattern = "提高所有法术和效果对亡灵所造成的伤害，最多(%d+)点。", effect = "DMGUNDEAD"},
		{ pattern = "法术和魔法效果对亡灵造成的伤害提高最多(%d+)点。", effect = "DMGUNDEAD"},
		{ pattern = "使魔法和法术效果对亡灵造成的伤害提高最多(%d+)点。同时也可为银色黎明收集天灾石。",	effect = "DMGUNDEAD"},
		{ pattern = "与亡灵作战时的攻击强度提高(%d+)点。同时也可获得天灾石。", effect = "ATTACKPOWERUNDEAD"}, 
		{ pattern = "对亡灵的攻击强度提高(%d+)点。", effect = "ATTACKPOWERUNDEAD"},
		{ pattern = "每5秒回复(%d+)点生命值。", effect = "HEALTHREG" }, 
		{ pattern = "每5秒恢复(%d+)点生命值。", effect = "HEALTHREG" },  -- both versions ('per' and 'every') seem to be used
		{ pattern = "每5秒恢复(%d+)点法力值。", effect = "MANAREG" },
		{ pattern = "每5秒回复(%d+)点法力值。", effect = "MANAREG" },
		{ pattern = "使你击中目标的几率提高(%d+)%%。", effect = "TOHIT" },
		{ pattern = "使你的法术击中敌人的几率提高(%d+)%%。", effect = "SPELLTOHIT" },
		{ pattern = "使你的法术目标的魔法抗性降低(%d+)点。", effect = "SPELLPEN" },

		-- Added for HealPoints
		{ pattern = "使你在施法时仍保持(%d+)%%的法力回复速度。", effect = "CASTINGREG"},		
		{ pattern = "使你的自然系法术造成致命一击的几率提高(%d+)%%。", effect = "NATURECRIT"}, 
		{ pattern = "使你的愈合法术的施法时间减少0%.(%d+)秒。", effect = "CASTINGREGROWTH"}, 
		{ pattern = "使你的圣光术的施法时间减少0%.(%d+)秒。", effect = "CASTINGHOLYLIGHT"},
		{ pattern = "使你的治疗之触法术的施法时间减少0%.(%d+)秒。", effect = "CASTINGHEALINGTOUCH"},
		{ pattern = "使你的快速治疗法术的施法时间减少0%.(%d+)秒。", effect = "CASTINGFLASHHEAL"},
		{ pattern = "治疗链法术的施法时间减少0%.(%d+)秒。", effect = "CASTINGCHAINHEAL"},
		{ pattern = "使你的回春术的持续时间延长(%d+)秒。", effect = "DURATIONREJUV"},
		{ pattern = "使你的恢复术的持续时间延长(%d+)秒。", effect = "DURATIONRENEW"},
		{ pattern = "使你在普通状态下的生命值和法力值回复提高(%d+)点。", effect = "MANAREGNORMAL"},
		{ pattern = "使法术在治疗除了第一个目标以外的其它目标时的效果提高(%d+)%%。", effect = "IMPCHAINHEAL"},
		{ pattern = "使回春术所恢复的生命值提高最多(%d+)点。", effect = "IMPREJUVENATION"},
		{ pattern = "使次级治疗波的治疗效果提高(%d+)点。", effect = "IMPLESSERHEALINGWAVE"},
		{ pattern = "使圣光闪现的治疗效果提高(%d+)点。", effect = "IMPFLASHOFLIGHT"},
		{ pattern = "在你施放了治疗波或次级治疗波法术之后，有25%%的几率获得该法术所消耗的法力值的(%d+)%%。", effect = "REFUNDHEALINGWAVE"},
		{ pattern = "你的治疗波会治疗一个额外的目标。治疗波每次跳跃后的治疗效果都会降低(%d+)%%，并治疗最多2个额外的目标。", effect = "JUMPHEALINGWAVE"},
		{ pattern = "使你的治疗之触、愈合和宁静所消耗的法力值减少(%d+)%%。", effect = "CHEAPERDRUID"},
		{ pattern = "治疗之触的极效治疗效果可以使你恢复该法术所消耗法力值的(%d+)%%。", effect = "REFUNDHTCRIT"},
		{ pattern = "使你的恢复法术所消耗的法力值降低(%d+)%%。", effect = "CHEAPERRENEW"},
	};

	-- generic patterns have the form "+xx bonus" or "bonus +xx" with an optional % sign after the value.

	-- first the generic bonus string is looked up in the following table
	PATTERNS_GENERIC_LOOKUP = {
		["所有属性"] 			= {"STR", "AGI", "STA", "INT", "SPI"},
		["力量"]				= "STR",
		["敏捷"]				= "AGI",
		["耐力"]				= "STA",
		["智力"]				= "INT",
		["精神"] 				= "SPI",

		["所有抗性"] 	= { "ARCANERES", "FIRERES", "FROSTRES", "NATURERES", "SHADOWRES", "ALLRES"},

		["钓鱼"]				= "FISHING",
		["鱼饵"]				= "FISHING",
		--["Increased Fishing"]	= "FISHING",
		["采矿"]				= "MINING",
		["草药"]				= "HERBALISM",
		["剥皮"]				= "SKINNING",
		["防御"]				= "DEFENSE",
		--["Increased Defense"]	= "DEFENSE",

		["攻击强度。"] 			= "ATTACKPOWER",
		["攻击强度"] 			= "ATTACKPOWER",
		["攻击强度vs亡灵.*$"] 		= "ATTACKPOWERUNDEAD",
		["在猎豹、熊、巨熊或枭兽形态下的攻击强度"] = "ATTACKPOWERFERAL",

		["闪躲"] 				= "DODGE",
		["躲闪"] 				= "DODGE",
		["躲避"] 				= "DODGE",
		["闪避"] 				= "DODGE",
		["格挡"]				= "BLOCK",
		["盾牌格挡"]			= "BLOCK",		
		["格挡值"]				= "BLOCKVALUE",
		["命中"] 				= "TOHIT",
		["法术命中"]			= "SPELLTOHIT",
		["远程攻击强度"]		= "RANGEDATTACKPOWER",
		["每5秒回复生命"] 		= "HEALTHREG",
		["治疗法术"] 			= "HEAL",
		--["Increases Healing"] 	= "HEAL",
		["治疗和法术伤害"] 		= {"HEAL", "DMG"},
		["伤害和治疗法术"] 		= {"HEAL", "DMG"},
		["法术治疗和伤害"] 		= {"HEAL", "DMG"},
		["法术伤害和治疗"] 		= {"HEAL", "DMG"},	
		["法术伤害"] 			= {"HEAL", "DMG"},		
		["每5秒恢复法力"] 		= "MANAREG",
		["法力回复"]			= "MANAREG",
		--["Critical"] 			= "CRIT",
		--["Critical Hit"] 		= "CRIT",
		["伤害"] 				= "DMG",
		["生命值"]				= "HEALTH",
		--["HP"]					= "HEALTH",
		["法力值"]				= "MANA",
		["护甲"]				= "ARMOR",
		["强化护甲"]			= "ARMOR",	
	};	

	-- next we try to match against one pattern of stage 1 and one pattern of stage 2 and concatenate the effect strings
	PATTERNS_GENERIC_STAGE1 = {
		{ pattern = "奥术", 	effect = "ARCANE" },	
		{ pattern = "火焰", 	effect = "FIRE" },	
		{ pattern = "冰霜", 	effect = "FROST" },	
		{ pattern = "神圣", 	effect = "HOLY" },	
		{ pattern = "暗影",	effect = "SHADOW" },	
		{ pattern = "自然", 	effect = "NATURE" }
	}; 	

	PATTERNS_GENERIC_STAGE2 = {
		{ pattern = "抗性", 	effect = "RES" },	
		{ pattern = "伤害", 	effect = "DMG" },
		{ pattern = "效果", 	effect = "DMG" },
	}; 	

	-- finally if we got no match, we match against some special enchantment patterns.
	PATTERNS_OTHER = {
		{ pattern = "每5秒恢复(%d+)点法力值[。]", effect = "MANAREG" },
		
		{ pattern = "初级巫师之油", effect = {"DMG", "HEAL"}, value = 8 },
		{ pattern = "次级巫师之油", effect = {"DMG", "HEAL"}, value = 16 },
		{ pattern = "巫师之油", effect = {"DMG", "HEAL"}, value = 24 },
		{ pattern = "卓越巫师之油", effect = {"DMG", "HEAL", "SPELLCRIT"}, value = {36, 36, 1} },
		{ pattern = "初级法力之油", effect = "MANAREG", value = 4 },
		{ pattern = "次级法力之油", effect = "MANAREG", value = 8 },
		{ pattern = "卓越法力之油", effect = { "MANAREG", "HEAL"}, value = {12, 25} },
		{ pattern = "恒金渔线", effect = "FISHING", value = 5 }, 
		
		{ pattern = "(%d+)格挡", effect = "BLOCK"},
		{ pattern = "(%d+)点格挡", effect = "BLOCK"},
		{ pattern = "格挡 +(%d+)%%", effect = "TOBLOCK"},	-- thanks imole @mop
		{ pattern = "(%d+)点护甲", effect = "ARMOR"},
		{ pattern = "每5秒恢复(%d+)点生命值[。]", effect = "HEALTHREG" },
		{ pattern = "每5秒回复(%d+)点生命值[。]", effect = "HEALTHREG" },
		{ pattern = "赞达拉魔力徽章", effect = {"DMG", "HEAL"}, value = 18 },
		{ pattern = "赞达拉宁静徽章", effect = "HEAL", value = 33 },
		{ pattern = "赞达拉力量徽章", effect = "ATTACKPOWER", value = 30 },		
		
		{ pattern = "治疗%+31点，每5秒回复5点法力值", effect = { "MANAREG", "HEAL"}, value = {5, 31} },
		{ pattern = "耐力%+16点，护甲%+100点", effect = { "STA", "ARMOR"}, value = {16, 100} },
		{ pattern = "攻击强度%+26点，致命一击率%+1%%", effect = { "ATTACKPOWER", "CRIT"}, value = {26, 1} },
		{ pattern = "法术伤害%+15点，法术致命一击率%+1%%", effect = { "DMG", "HEAL", "SPELLCRIT"}, value = {15, 15, 1} },
		


		--Twow new Ring echants
		{ pattern = "提高治疗效果 %+12", effect = { "HEAL"}, value = {12} },
		
		--twow new t3 flash of light set bonus
		{ pattern = "使你的光明审判的治疗量提高20，圣光闪现的治疗量提高60。", effect = { "IMPFLASHOFLIGHT"}, value = {60}},
	}
} end)
