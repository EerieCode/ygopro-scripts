--アストログラフ・マジシャン
function c76794549.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(76794549,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,76794549)
	e1:SetTarget(c76794549.rptg)
	e1:SetOperation(c76794549.rpop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76794549,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c76794549.spcon)
	e2:SetTarget(c76794549.sptg)
	e2:SetOperation(c76794549.spop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76794549,5))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetCost(c76794549.hncost)
	e3:SetTarget(c76794549.hntg)
	e3:SetOperation(c76794549.hnop)
	c:RegisterEffect(e3)
end
function c76794549.rpfilter(c,e,tp)
	return c:IsCode(94415058) and (not c:IsForbidden()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c76794549.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76794549.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c76794549.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectMatchingCard(tp,c76794549.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local op=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			op=Duel.SelectOption(tp,aux.Stringid(76794549,1),aux.Stringid(76794549,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(76794549,1))
		end
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c76794549.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c76794549.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c76794549.spcfilter,1,nil,tp)
end
function c76794549.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c76794549.thfilter1(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_DESTROY) and c:GetTurnID()==id
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c76794549.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c76794549.thfilter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c76794549.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c76794549.thfilter1,tp,0x70,0x70,nil,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(76794549,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local cg=g:Select(tp,1,1,nil)
			Duel.HintSelection(cg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c76794549.thfilter2,tp,LOCATION_DECK,0,1,1,nil,cg:GetFirst())
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c76794549.hncfilter(c,sc)
	return c:IsSetCard(sc) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c76794549.hncost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c76794549.hncfilter,tp,loc,0,1,nil,0x10f2)
		and Duel.IsExistingMatchingCard(c76794549.hncfilter,tp,loc,0,1,nil,0x2073)
		and Duel.IsExistingMatchingCard(c76794549.hncfilter,tp,loc,0,1,nil,0x2017)
		and Duel.IsExistingMatchingCard(c76794549.hncfilter,tp,loc,0,1,nil,0x1046)
	end
	local g=Group.FromCards(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c76794549.hncfilter,tp,loc,0,1,1,nil,0x10f2)
	g:Merge(g1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c76794549.hncfilter,tp,loc,0,1,1,nil,0x2073)
	g:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c76794549.hncfilter,tp,loc,0,1,1,nil,0x2017)
	g:Merge(g3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g4=Duel.SelectMatchingCard(tp,c76794549.hncfilter,tp,loc,0,1,1,nil,0x1046)
	g:Merge(g4)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c76794549.hnfilter(c,e,tp)
	return c:IsFacedown() and c:IsCode(100912039) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c76794549.hntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c76794549.hnfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c76794549.hnop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76794549.hnfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	end
end