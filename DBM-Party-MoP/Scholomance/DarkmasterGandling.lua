local mod	= DBM:NewMod(684, "DBM-Party-MoP", 7, 246)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,challenge,timewalker"

mod:SetRevision("@file-date-integer@")
mod:SetCreatureID(59080)
mod:SetEncounterID(1430)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 113143",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warnLesson		= mod:NewTargetNoFilterAnnounce(113395, 2)--Needs to be changed to target when transcriptor works, at present CLEU doesn't show anything.
local warnRise			= mod:NewSpellAnnounce(113143, 3)

local timerLessonCD		= mod:NewNextTimer(30, 113395, nil, nil, nil, 3)
local timerRiseCD		= mod:NewNextTimer(62.5, 113143, nil, nil, nil, 1)--Assuming this is even CD based, it could be boss health based, in which case timer is worthless

function mod:OnCombatStart(delay)
	timerLessonCD:Start(17-delay)
	timerRiseCD:Start(48-delay)--Assumed based off a single log. This may be health based.
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 113143 then
		warnRise:Show()
		timerRiseCD:Start()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)--Just until there is a better way
	if msg:find("spell:113395") then
		warnLesson:Show(DBM:GetUnitFullName(target))
		timerLessonCD:Start()
	end
end
