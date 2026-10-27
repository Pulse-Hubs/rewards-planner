-- NEXUS HUB 11.7 | MOBILE | ESP ROLES + AUTO RESET
-- Codigo local Luau para cliente Roblox. Sem URL, webhook, request, loadstring ou dependencias externas.
-- Farm e ESP dependem da estrutura do jogo; coleta/identificacao nao sao garantidas.
-- Construir a interface PRIMEIRO. Nao varrer o mapa na inicializacao.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local me = Players.LocalPlayer
if not me then return end
local pg = me:FindFirstChildOfClass("PlayerGui") or me:WaitForChild("PlayerGui", 8)
if not pg then return end

-- Limpa somente o proprio menu anterior. Evita multiplos Heartbeats e farms paralelos.
pcall(function()
    if type(_G.NexusMobileStop)=="function" then _G.NexusMobileStop() end
end)
for _,name in ipairs({"NexusMobile117","NexusErroInicializacao"}) do
    local g=pg:FindFirstChild(name)
    if g then g:Destroy() end
end

local T={bg=Color3.fromRGB(13,12,23),side=Color3.fromRGB(22,19,36),panel=Color3.fromRGB(36,31,54),
    accent=Color3.fromRGB(173,89,251),edge=Color3.fromRGB(86,67,125),white=Color3.fromRGB(249,244,255),
    dim=Color3.fromRGB(176,166,198),good=Color3.fromRGB(110,240,179),bad=Color3.fromRGB(255,90,128)}
local S={tab="Farm",farm=false,method="Fast",speed=28,pause=.01,noclip=true,
    autoReset=false,avoid=false,avoidRange=26,antiFling=true,afkWarning=true,underDepth=1.1,
    espAll=false,espInnocent=false,espSheriff=false,espMurder=false,coinEsp=false,
    names=true,distances=true,role="Desconhecido",roleSource="Sem dados",bag=0,bagMax=0,bagInfo="Aguardando coleta",bagSource="Nenhuma",resetting=false,resetAttempted=false,
    status="Pronto",scanned=0,candy=0,contacts=0,removed=0,reroutes=0,resets=0,seen=0,rolesFound=0,
    lastError="Nenhum",fullBag=false,motion=true,theme=1,scale=1,stage="Menu aberto"}
local live=true
local function make(class, props, parent)
    local o=Instance.new(class)
    for k,v in pairs(props or {}) do o[k]=v end
    o.Parent=parent
    return o
end
local function round(o,n) make("UICorner",{CornerRadius=UDim.new(0,n or 7)},o) return o end
local function txt(parent,string,size,color,bold)
    return make("TextLabel",{BackgroundTransparency=1,Text=tostring(string),TextSize=size or 12,
        Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,TextColor3=color or T.white,
        TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center},parent)
end
local function btn(parent,title)
    local b=make("TextButton",{Text=title,Font=Enum.Font.GothamBold,TextSize=12,
        TextColor3=T.white,BackgroundColor3=T.panel,BorderSizePixel=0,AutoButtonColor=true},parent)
    round(b,7)
    return b
end

local screen=make("ScreenGui",{Name="NexusMobile117",ResetOnSpawn=false,DisplayOrder=540,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling},pg)
local win=round(make("Frame",{Name="Window",Size=UDim2.fromOffset(650,420),
    Position=UDim2.fromScale(.5,.5),AnchorPoint=Vector2.new(.5,.5),
    BackgroundColor3=T.bg,BorderSizePixel=0,ClipsDescendants=true},screen),13)
local sc=make("UIScale",{Scale=1},win)
local side=make("Frame",{Size=UDim2.new(0,177,1,0),BorderSizePixel=0,
    BackgroundColor3=T.side},win)
local rail=make("Frame",{Size=UDim2.new(1,0,0,3),BackgroundColor3=T.accent,BorderSizePixel=0},win)
local title=txt(side,"NEXUS",21,T.white,true)
title.Position=UDim2.fromOffset(15,13);title.Size=UDim2.fromOffset(145,26)
local edition=txt(side,"NIGHTFALL  •  11.7",9,T.accent,true)
edition.Position=UDim2.fromOffset(15,42);edition.Size=UDim2.fromOffset(155,16)
local open=btn(screen,"N")
open.Size=UDim2.fromOffset(45,45);open.Position=UDim2.new(0,10,.52,0)
open.BackgroundColor3=T.accent;open.Visible=false
local heading=txt(win,"FARM / HALLOWEEN",18,T.white,true)
heading.Active=true
heading.Position=UDim2.fromOffset(193,12);heading.Size=UDim2.fromOffset(374,28)
local subhead=txt(win,"Menu carregado • funções iniciam ao ativar",10,T.dim)
subhead.Position=UDim2.fromOffset(193,41);subhead.Size=UDim2.fromOffset(350,22)
local close=btn(win,"×");close.Size=UDim2.fromOffset(31,29);close.Position=UDim2.fromOffset(609,17)
local minimize=btn(win,"—");minimize.Size=UDim2.fromOffset(31,29);minimize.Position=UDim2.fromOffset(571,17)
local nav=make("ScrollingFrame",{Size=UDim2.fromOffset(167,320),Position=UDim2.fromOffset(5,69),
    BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=UDim2.new(),
    AutomaticCanvasSize=Enum.AutomaticSize.Y},side)
make("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3)},nav)
make("UIPadding",{PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),PaddingBottom=UDim.new(0,6)},nav)
local main=make("ScrollingFrame",{Position=UDim2.fromOffset(188,76),Size=UDim2.fromOffset(452,333),
    BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=UDim2.new(),
    AutomaticCanvasSize=Enum.AutomaticSize.Y},win)
local function fit()
    local cam=workspace.CurrentCamera
    if not cam then return end
    local v=cam.ViewportSize
    sc.Scale=math.max(.44,math.min(1,v.X/666,v.Y/445))*S.scale
end
fit()
local allConnections={}
local function listen(event,cb)
    local c=event:Connect(cb); allConnections[#allConnections+1]=c; return c
end
listen(workspace:GetPropertyChangedSignal("CurrentCamera"),fit)
listen(RunService.Heartbeat,function() -- viewport pode mudar ao girar o celular
    if not live then return end
    local cam=workspace.CurrentCamera
    if cam and sc then
        local v=cam.ViewportSize
        local target=math.max(.44,math.min(1,v.X/666,v.Y/445))*S.scale
        if math.abs(sc.Scale-target)>.015 then sc.Scale=target end
    end
end)
local render
local connectionsPage={}
local function pageConnect(ev,fn)
    local c=ev:Connect(fn);connectionsPage[#connectionsPage+1]=c
end
local function addRow(name,description)
    local row=round(make("Frame",{BackgroundColor3=T.panel,Size=UDim2.new(1,-9,0,51),
        BorderSizePixel=0},main),8)
    local lab=txt(row,name,12,T.white,true)
    lab.Position=UDim2.fromOffset(11,4);lab.Size=UDim2.new(1,-142,0,21)
    local explain=txt(row,description or "",9,T.dim)
    explain.Position=UDim2.fromOffset(11,26);explain.Size=UDim2.new(1,-142,0,17)
    return row
end
local function addText(value)
    local t=txt(main,value,11,T.dim)
    t.Size=UDim2.new(1,-10,0,40);t.TextWrapped=true
    return t
end
local function action(label,desc,buttonName,fn)
    local row=addRow(label,desc)
    local b=btn(row,buttonName or "Usar")
    b.Size=UDim2.fromOffset(116,31);b.Position=UDim2.new(1,-125,.5,-15)
    pageConnect(b.MouseButton1Click,function()
        local ok,err=pcall(fn)
        if not ok then S.lastError=tostring(err);S.status="Erro no controle" end
        if live then render() end
    end)
end
local function toggle(label,desc,key,fn)
    action(label,desc,S[key] and "LIGADO" or "DESLIGADO",function()
        S[key]=not S[key]
        if fn then fn(S[key]) end
    end)
end
local function pageClear()
    for _,c in ipairs(connectionsPage) do c:Disconnect() end
    table.clear(connectionsPage)
    for _,o in ipairs(main:GetChildren()) do o:Destroy() end
    make("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6)},main)
    make("UIPadding",{PaddingTop=UDim.new(0,2),PaddingRight=UDim.new(0,5),PaddingBottom=UDim.new(0,12)},main)
end
local function playerParts()
    local ch=me.Character
    return ch, ch and ch:FindFirstChildOfClass("Humanoid"), ch and ch:FindFirstChild("HumanoidRootPart")
end
local job=0
local flyVelocity,flyGyro,flyConn,oldAuto,oldHum,oldStand
local oldCollisions={}
local seenTargets=setmetatable({}, {__mode="k"})
local coins={}
local scanAt=-100
local indexAt=-100
local scanContainers={}
local looseCandidates={}
local bagConn
local roleEventConn
local roundConns={}
local roles={}
local roleAt=-100
local lastSafe
local safeReset
local espObjects={}
local coinHighlights={}

-- Só rotular papel confirmado por dados reais. Equipamento visto vira pista, não papel garantido.
local roleBusy=false
local roleUpdated=-100
local roleRequest=0
local function normalizeRole(r)
    if type(r)~="string" then return nil end
    r=string.lower(r):gsub("[%s_%-]", "")
    if r=="murderer" or r=="murder" then return "Murderer" end
    if r=="sheriff" or r=="hero" then return "Sheriff" end
    if r=="innocent" or r=="innocentdefault" or r=="inocente" then return "Inocente" end
    return nil
end
local function roleOf(p)
    if not p then return "Desconhecido" end
    local ch=p.Character
    local direct=normalizeRole(p:GetAttribute("Role")) or (ch and normalizeRole(ch:GetAttribute("Role")))
    if not direct then
        local val=p:FindFirstChild("Role") or (ch and ch:FindFirstChild("Role"))
        if val and val:IsA("StringValue") then direct=normalizeRole(val.Value) end
    end
    if not direct and p.Team then direct=normalizeRole(p.Team.Name) end
    if direct then return direct end
    if os.clock()-roleUpdated<=210 then
        local r=roles[string.lower(p.Name)] or roles[tostring(p.UserId)]
        if r then return r end
    end
    return "Desconhecido"
end
-- A consulta por GetPlayerData nao e a unica fonte no MM2.
-- Alguns servidores enviam PlayerDataChanged ao longo da rodada.
-- Receber o evento e mais eficiente que consultar repetidamente um RemoteFunction.
local function ingestRoles(data,source)
    if type(data)~="table" then return false end
    local result,found={},0
    local function save(key,role)
        if not role or not key then return end
        if typeof(key)=="Instance" and key:IsA("Player") then
            result[string.lower(key.Name)]=role
            result[tostring(key.UserId)]=role
        elseif type(key)=="string" or type(key)=="number" then
            result[string.lower(tostring(key))]=role
        end
    end
    local function crawl(tbl,depth)
        if depth>4 or type(tbl)~="table" then return end
        for key,entry in pairs(tbl) do
            if type(entry)=="table" then
                local role=normalizeRole(entry.Role or entry.role or entry.PlayerRole or entry.RoleName)
                if role then
                    found=found+1
                    save(key,role)
                    save(entry.Name or entry.name or entry.Username,role)
                    save(entry.UserId or entry.userId,role)
                    save(entry.Player or entry.player,role)
                else
                    crawl(entry,depth+1)
                end
            elseif type(entry)=="string" then
                -- Também aceita { NomeDoJogador = "Sheriff" }.
                local role=normalizeRole(entry)
                if role then found=found+1;save(key,role) end
            end
        end
    end
    crawl(data,0)
    if found==0 then
        S.roleSource=source..": nenhum papel reconhecido"
        return false
    end
    roles=result
    roleUpdated=os.clock()
    S.rolesFound=found
    S.roleSource=source..": "..tostring(found).." papéis"
    if S.autoReset and S.fullBag and safeReset then safeReset() end
    return true
end
local function updateRoles(force)
    local now=os.clock()
    -- Dados recentes do evento valem durante a rodada: nao refazer a consulta toda hora.
    if not force and now-roleUpdated<40 then return end
    if roleBusy or (not force and now-roleAt<8) then return end
    roleAt=now
    local remotes=ReplicatedStorage:FindFirstChild("Remotes")
    local gp=remotes and remotes:FindFirstChild("Gameplay")
    local getter=gp and gp:FindFirstChild("GetPlayerData")
    if not getter or not getter:IsA("RemoteFunction") then
        if roleUpdated<0 then S.roleSource="Aguardando PlayerDataChanged" end
        return
    end
    roleBusy=true
    roleRequest=roleRequest+1
    local request=roleRequest
    task.delay(5,function()
        if live and roleRequest==request and roleBusy then
            roleBusy=false
            S.roleSource="GetPlayerData demorou; aguardando evento"
        end
    end)
    task.spawn(function()
        local ok,data=pcall(function() return getter:InvokeServer() end)
        if not live or request~=roleRequest then return end
        if ok then
            if not ingestRoles(data,"Consulta GetPlayerData") and roleUpdated<0 then
                S.roleSource="Aguardando PlayerDataChanged"
            end
        elseif roleUpdated<0 then
            S.roleSource="GetPlayerData falhou; aguardando evento"
        end
        roleBusy=false
    end)
end
-- Buscar primeiro mapas ativos, SEM GetDescendants() em toda a workspace no clique de ativação.
local itemByPart=setmetatable({}, {__mode="k"})
local hadTouch=setmetatable({}, {__mode="k"})
local indexing=false
local function hasSensor(p)
    return p:FindFirstChild("TouchInterest")~=nil or p:FindFirstChildOfClass("TouchTransmitter")~=nil
end
local function collectibleAvailable(part)
    if not part or not part:IsA("BasePart") or not part:IsDescendantOf(workspace) then return false end
    local item=itemByPart[part]
    if item and not item.Parent then return false end
    if (item and item:GetAttribute("Collected")==true) or part:GetAttribute("Collected")==true then return false end
    if hadTouch[part] and not hasSensor(part) then return false end
    if item then
        local visual=item:FindFirstChild("CoinVisual",true) or item:FindFirstChild("CandyVisual",true)
        if visual and visual:IsA("BasePart") and visual.Transparency>=.98 then return false end
    end
    return true
end
local function addContainer(arr,found,obj)
    if obj and obj.Parent and not found[obj] then
        found[obj]=true;arr[#arr+1]=obj
    end
end
local function discoverContainers()
    local result,found={},{}
    for _,map in ipairs(workspace:GetChildren()) do
        local n=string.lower(map.Name)
        if n=="coincontainer" or n=="candycontainer" then addContainer(result,found,map) end
        local one=map:FindFirstChild("CoinContainer") or map:FindFirstChild("CandyContainer")
        addContainer(result,found,one)
        -- Um nível de pastas de mapa é suficiente para a varredura rápida.
        if not one and (map:IsA("Folder") or map:IsA("Model")) then
            for _,child in ipairs(map:GetChildren()) do
                local sub=child:FindFirstChild("CoinContainer") or child:FindFirstChild("CandyContainer")
                if sub then addContainer(result,found,sub) end
            end
        end
    end
    scanContainers=result
    -- Fallback raro, incremental e em segundo plano. Nunca bloqueia o botão Auto Farm.
    if #result==0 and not indexing then
        indexing=true
        task.spawn(function()
            local more,seen={},{}
            local queue={workspace}
            local index=1
            while live and index<=#queue do
                local parent=queue[index]
                index=index+1
                for _,obj in ipairs(parent:GetChildren()) do
                    local n=string.lower(obj.Name)
                    if n=="coincontainer" or n=="candycontainer" then
                        addContainer(more,seen,obj)
                    elseif obj:IsA("BasePart") and (n=="coin_server" or n=="candy_server") then
                        looseCandidates[#looseCandidates+1]=obj
                    end
                    if obj:IsA("Model") or obj:IsA("Folder") then
                        queue[#queue+1]=obj
                    end
                end
                if index%40==0 then task.wait() end
            end
            if live and #scanContainers==0 then scanContainers=more end
            indexing=false
        end)
    end
end
local function sensorFor(item)
    if not item or not item.Parent then return end
    if item:IsA("BasePart") and hasSensor(item) then return item end
    for _,p in ipairs(item:GetDescendants()) do
        if p:IsA("BasePart") and hasSensor(p) then return p end
    end
    if item:IsA("BasePart") then return item end
    local visual=item:FindFirstChild("CoinVisual",true) or item:FindFirstChild("CandyVisual",true)
    if visual and visual:IsA("BasePart") then return visual end
    return item:FindFirstChildWhichIsA("BasePart",true)
end
local function scan(force)
    local now=os.clock()
    if not force and now-scanAt<(#coins==0 and .15 or .32) then return coins end
    scanAt=now
    if now-indexAt>2.5 or (#scanContainers==0 and now-indexAt>.7) then
        indexAt=now
        discoverContainers()
    end
    local found,unique={},{}
    local function add(item)
        if not item or not item.Parent then return end
        if item:GetAttribute("Collected")==true then return end
        local p=sensorFor(item)
        if not p or unique[p] then return end
        unique[p]=true
        itemByPart[p]=item
        if hasSensor(p) then hadTouch[p]=true end
        if collectibleAvailable(p) then found[#found+1]=p end
    end
    for _,cont in ipairs(scanContainers) do
        if cont.Parent then
            for _,item in ipairs(cont:GetChildren()) do add(item) end
        end
    end
    if #scanContainers==0 then
        for _,part in ipairs(looseCandidates) do if part.Parent then add(part) end end
    end
    coins=found;S.scanned=#found;S.candy=#found
    return coins
end
local function suspiciousMurderer(p)
    -- Usa somente informação explícita de papel; sem adivinhação.
    return roleOf(p)=="Murderer"
end
local function routeSafe(from,goal)
    if not S.avoid then return true end
    local dx,dz=goal.X-from.X,goal.Z-from.Z
    local segment=dx*dx+dz*dz
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=me and suspiciousMurderer(p) then
            local root=p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local pos=root.Position
                local t=segment>.001 and math.clamp(((pos.X-from.X)*dx+(pos.Z-from.Z)*dz)/segment,0,1) or 0
                local ax,az=from.X+dx*t-pos.X,from.Z+dz*t-pos.Z
                if ax*ax+az*az<S.avoidRange*S.avoidRange then return false end
            end
        end
    end
    return true
end
local function pickCoin()
    local _,_,root=playerParts()
    if not root then return end
    local best,bestDistance=nil,math.huge
    for _,p in ipairs(scan(false)) do
        if p.Parent and (seenTargets[p] or 0)<os.clock() and routeSafe(root.Position,p.Position) then
            local d=(root.Position-p.Position).Magnitude
            if d<bestDistance then best=p;bestDistance=d end
        end
    end
    return best
end
local function stopMove()
    if flyConn then flyConn:Disconnect();flyConn=nil end
    if flyVelocity then flyVelocity:Destroy();flyVelocity=nil end
    if flyGyro then flyGyro:Destroy();flyGyro=nil end
    for part,original in pairs(oldCollisions) do
        if part and part.Parent then pcall(function()part.CanCollide=original end) end
    end
    table.clear(oldCollisions)
    if oldHum and oldHum.Parent then
        if oldAuto~=nil then oldHum.AutoRotate=oldAuto end
        if oldStand~=nil then oldHum.PlatformStand=oldStand end
    end
    oldHum=nil;oldAuto=nil;oldStand=nil
end
local function stopFarm()
    job=job+1;S.farm=false;S.status="Farm desligado"
    local _,_,root=playerParts()
    if flyVelocity then flyVelocity.Velocity=Vector3.zero end
    stopMove()
    if S.method=="Under Map" and root and lastSafe then pcall(function()root.CFrame=lastSafe end) end
end

local function motor()
    local ch,hum,root=playerParts()
    if not ch or not hum or not root or hum.Health<=0 then return end
    if not flyVelocity or flyVelocity.Parent~=root then
        stopMove()
        oldAuto=hum.AutoRotate;oldStand=hum.PlatformStand;oldHum=hum
        hum.AutoRotate=false
        if S.method=="Under Map" then hum.PlatformStand=true end
        flyVelocity=make("BodyVelocity",{Name="NexusMotion116",MaxForce=Vector3.new(2e7,2e7,2e7),
            P=16000,Velocity=Vector3.zero},root)
        flyGyro=make("BodyGyro",{Name="NexusDirection116",MaxTorque=Vector3.new(1e7,1e7,1e7),
            P=9500,D=850,CFrame=root.CFrame},root)
        local clipChar=nil
        local clipParts={}
        local nextBuild=0
        flyConn=RunService.Stepped:Connect(function()
            if not live or not S.farm or not S.noclip then return end
            local cur=me.Character
            if not cur then return end
            if cur~=clipChar or os.clock()>=nextBuild then
                clipChar=cur;nextBuild=os.clock()+1
                table.clear(clipParts)
                for _,p in ipairs(cur:GetDescendants()) do
                    if p:IsA("BasePart") then
                        clipParts[#clipParts+1]=p
                        if oldCollisions[p]==nil then oldCollisions[p]=p.CanCollide end
                    end
                end
            end
            for _,p in ipairs(clipParts) do if p.Parent and p.CanCollide then p.CanCollide=false end end
        end)
    end
    return root
end
local function drive(goal,target,limit)
    local start=os.clock()
    local bestDist=math.huge
    local lastProgress=os.clock()
    local previous=nil
    while live and S.farm and collectibleAvailable(target) and os.clock()-start<limit do
        local root=motor()
        if not root then return false,"personagem indisponível" end
        if not routeSafe(root.Position,target.Position) then
            S.reroutes=S.reroutes+1;return false,"rota insegura"
        end
        local delta=goal-root.Position
        local d=delta.Magnitude
        if d<.38 then
            if flyVelocity then flyVelocity.Velocity=Vector3.zero end
            return true,"chegou"
        end
        if d<bestDist-.08 then bestDist=d;lastProgress=os.clock() end
        if os.clock()-lastProgress>1.65 then
            if flyVelocity then flyVelocity.Velocity=Vector3.zero end
            return false,"sem progresso"
        end
        -- Desaceleração progressiva ao se aproximar evita atravessar o alvo.
        local vel=math.min(S.speed,math.max(2.4,d*5))
        if flyVelocity then flyVelocity.Velocity=delta.Unit*vel end
        if flyGyro then
            local f=Vector3.new(target.Position.X-root.Position.X,0,target.Position.Z-root.Position.Z)
            if f.Magnitude>.2 then
                local cf=CFrame.lookAt(root.Position,root.Position+f.Unit)
                flyGyro.CFrame=S.method=="Under Map" and cf*CFrame.Angles(math.rad(90),0,0) or cf
            end
        end
        RunService.Heartbeat:Wait()
    end
    return false,"alvo expirou"
end
local function highCandy(target)
    -- Comparar a altura com os doces do piso principal, não com um único outlier.
    local ys={}
    for _,p in ipairs(coins) do
        if collectibleAvailable(p) then ys[#ys+1]=p.Position.Y end
    end
    if #ys<2 then return false end
    table.sort(ys)
    local q=ys[math.max(1,math.ceil(#ys*.25))]
    return target.Position.Y>q+8
end
local function startFarm()
    if S.farm then return end
    job=job+1
    local id=job
    S.farm=true;S.status="Iniciando busca rápida...";S.stage="Procurando doce"
    local _,_,root=playerParts();lastSafe=root and root.CFrame or nil
    task.spawn(function()
        local ok,err=pcall(function()
            local locked=nil
            local failures=0
            while live and S.farm and job==id do
                local _,hum,rr=playerParts()
                if not rr or not hum or hum.Health<=0 then
                    stopMove();locked=nil;task.wait(.15)
                else
                    if not collectibleAvailable(locked) or (locked and (seenTargets[locked] or 0)>os.clock()) then
                        locked=nil;failures=0
                    end
                    if not locked then locked=pickCoin() end
                    if not locked then
                        S.status="Procurando doces disponíveis..."
                        if flyVelocity then flyVelocity.Velocity=Vector3.zero end
                        task.wait(.10)
                    else
                        local target=locked
                        S.status="Alvo fixo: "..target.Name
                        local elevated=S.method=="Under Map" and highCandy(target)
                        local goal=target.Position+Vector3.new(0,.15,0)
                        if S.method=="Under Map" and not elevated then
                            -- Doces no chão: deslocar-se por baixo sem subir até a superfície.
                            -- Centro do corpo abaixo do doce, mas dentro do alcance físico do sensor quando possível.
                            -- Um coletável totalmente acima do piso pode ser inalcançável sem subir.
                            local _,_,curRoot=playerParts()
                            local reach=curRoot and (target.Size.Y+curRoot.Size.Y)*.5-.14 or S.underDepth
                            local offset=math.max(.45,math.min(S.underDepth,reach))
                            goal=Vector3.new(target.Position.X,target.Position.Y-offset,target.Position.Z)
                        end
                        local arrived,reason=drive(goal,target,math.max(3.2,(rr.Position-goal).Magnitude/math.max(8,S.speed)*2.5+1.7))
                        if arrived then
                            S.contacts=S.contacts+1
                            S.stage=elevated and "Contato em área elevada" or (S.method=="Under Map" and "Tentando contato por baixo" or "Tentando contato direto")
                            if flyVelocity then flyVelocity.Velocity=Vector3.zero end
                            task.wait(S.pause)
                            -- Não forçar uma troca de rumo no mesmo instante se o coletável seguir presente.
                            if not collectibleAvailable(target) then
                                S.removed=S.removed+1
                                locked=nil;failures=0
                            elseif failures==0 then
                                -- Repete uma vez o mesmo alvo, sem nova pausa adicional.
                                failures=1
                            else
                                seenTargets[target]=os.clock()+3
                                if S.method=="Under Map" then
                                    S.status="Doce não registrado; evitando repetir sem parar"
                                end
                                locked=nil;failures=0
                            end
                        else
                            S.stage="Falha de trajeto: "..tostring(reason)
                            if S.method=="Under Map" then
                                S.status="Under Map: verifique se o sensor do doce é alcançável por baixo"
                            end
                            failures=failures+1
                            if failures>=2 or reason=="rota insegura" then
                                seenTargets[target]=os.clock()+3
                                if S.method=="Under Map" then
                                    S.status="Doce não registrado; evitando repetir sem parar"
                                end
                                locked=nil;failures=0
                            else
                                -- Tentar o mesmo alvo uma segunda vez antes de trocar a rota.
                                task.wait(.04)
                            end
                        end
                    end
                end
            end
        end)
        if not ok then S.lastError=tostring(err);S.status="Erro no Farm" end
        if job==id then S.farm=false;stopMove() end
    end)
end
local function clearEsp()
    for _,item in pairs(espObjects) do
        if item.mark and item.mark.Parent then item.mark:Destroy() end
        if item.tag and item.tag.Parent then item.tag:Destroy() end
    end
    table.clear(espObjects)
end
local function espOn(role)
    return S.espAll or (role=="Murderer" and S.espMurder)
        or (role=="Sheriff" and S.espSheriff) or (role=="Inocente" and S.espInnocent)
end
local function updateEsp()
    local count=0
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=me then
            local ch=p.Character
            local head=ch and ch:FindFirstChild("Head")
            local role=roleOf(p)
            local show=espOn(role) and head~=nil
            local item=espObjects[p]
            if item and (not show or item.character~=ch) then
                if item.mark then item.mark:Destroy() end
                if item.tag then item.tag:Destroy() end
                espObjects[p]=nil;item=nil
            end
            if show then
                local color=(role=="Murderer") and T.bad or (role=="Sheriff") and Color3.fromRGB(70,160,255)
                    or role=="Inocente" and T.good or T.accent
                if not item then
                    local mark=make("Highlight",{Name="NexusPlayer117",Adornee=ch,FillTransparency=.7,
                        OutlineTransparency=0,DepthMode=Enum.HighlightDepthMode.AlwaysOnTop},ch)
                    local tag=make("BillboardGui",{Name="NexusLabel117",Adornee=head,
                        Size=UDim2.fromOffset(170,41),StudsOffset=Vector3.new(0,2.2,0),
                        AlwaysOnTop=true},ch)
                    local l=txt(tag,"",12,T.white,true)
                    l.Size=UDim2.fromScale(1,1);l.TextXAlignment=Enum.TextXAlignment.Center
                    item={mark=mark,tag=tag,label=l,character=ch};espObjects[p]=item
                end
                item.mark.FillColor=color;item.mark.OutlineColor=color
                local _,_,myRoot=playerParts()
                local hisRoot=ch:FindFirstChild("HumanoidRootPart")
                local distance=myRoot and hisRoot and math.floor((myRoot.Position-hisRoot.Position).Magnitude) or nil
                item.label.Text=(S.names and p.DisplayName or "Jogador").." / "..role..
                    (S.distances and distance and (" / "..distance.." studs") or "")
                item.label.TextColor3=color
                count=count+1
            end
        end
    end
    for p,item in pairs(espObjects) do
        if not p.Parent then
            if item.mark then item.mark:Destroy() end
            if item.tag then item.tag:Destroy() end
            espObjects[p]=nil
        end
    end
    S.seen=count
end
safeReset=function()
    if not S.autoReset or not S.fullBag or S.resetting or S.resetAttempted then return end
    S.role=roleOf(me)
    -- Nunca resetar se for Murderer ou se o papel não estiver confirmado.
    if S.role~="Inocente" and S.role~="Sheriff" then
        S.bagInfo="Sacola cheia; reset protegido ("..S.role..")"
        return
    end
    local _,h=playerParts()
    if h and h.Health>0 then
        S.resetting=true
        S.resetAttempted=true
        if S.farm then stopFarm() end
        local ok,err=pcall(function() h.Health=0 end)
        if ok then
            S.resets=S.resets+1
            S.bagInfo="Sacola cheia: reset solicitado"
        else
            S.lastError=tostring(err)
            S.bagInfo="Reset falhou: "..tostring(err):sub(1,50)
            S.resetting=false
        end
        task.delay(3,function()
            if live and S.resetting and me.Character==h.Parent and h.Health>0 then
                S.bagInfo="Reset nao confirmado pelo jogo"
            end
            if live then S.resetting=false end
        end)
    end
end
local function validBag(current,maxVal,source)
    if type(current)~="number" or type(maxVal)~="number" then return false end
    if current<0 or maxVal<20 or maxVal>150 or current>maxVal then return false end
    if current~=math.floor(current) or maxVal~=math.floor(maxVal) then return false end
    S.bag=current;S.bagMax=maxVal;S.fullBag=(current>=maxVal)
    if not S.fullBag then S.resetAttempted=false end
    S.bagSource=source or "Coleta"
    S.bagInfo=tostring(S.bag).." / "..tostring(S.bagMax).." ("..S.bagSource..")"
    if S.fullBag then safeReset() end
    return true
end
local function updateBag(...)
    local nums={}
    for _,v in ipairs({...}) do
        if type(v)=="number" and v==v then
            nums[#nums+1]=v
        elseif type(v)=="table" then
            local cur=v.Current or v.current or v.Amount or v.amount or v.Count or v.count
            local max=v.Max or v.max or v.Capacity or v.capacity or v.Limit or v.limit
            if type(cur)=="number" and type(max)=="number" then
                nums[#nums+1]=cur;nums[#nums+1]=max
            end
        end
    end
    if #nums>=2 then validBag(nums[#nums-1],nums[#nums],"Evento") end
end
-- Leitura alternativa da sacola pela interface, sem assumir 50/50 nem ler números de qualquer aba.
local guiBagReadAt=-100
local function readBagGui()
    if not S.autoReset or os.clock()-guiBagReadAt<.45 then return end
    guiBagReadAt=os.clock()
    local bestA,bestB,bestScore
    for _,o in ipairs(pg:GetDescendants()) do
        if (o:IsA("TextLabel") or o:IsA("TextButton")) and o.Visible
            and not o:IsDescendantOf(screen) then
            local a,b=o.Text:match("(%d+)%s*/%s*(%d+)")
            a=tonumber(a);b=tonumber(b)
            if a and b and a<=b and b>=20 and b<=150 then
                local node=o
                local score=0
                for _=1,6 do
                    if not node or node==pg then break end
                    local n=string.lower(node.Name)
                    if n:find("coin",1,true) or n:find("candy",1,true)
                        or n:find("bag",1,true) or n:find("sack",1,true) then score=score+1 end
                    node=node.Parent
                end
                if score>0 and (not bestScore or score>bestScore) then
                    bestA,bestB,bestScore=a,b,score
                end
            end
        end
    end
    if bestA and bestB then validBag(bestA,bestB,"HUD") end
end
listen(me.CharacterAdded,function()
    S.bag=0;S.bagMax=0;S.fullBag=false;S.resetting=false;S.resetAttempted=false;S.bagInfo="Nova rodada/respawn"
    roles={};roleUpdated=-100;roleAt=-100;S.rolesFound=0
    stopMove()
end)

local palette={{"NIGHTFALL",Color3.fromRGB(173,89,251)},
    {"INFERNO",Color3.fromRGB(255,119,60)},
    {"AQUA",Color3.fromRGB(55,215,241)},
    {"ROSE",Color3.fromRGB(255,90,163)}}
local tabs={"Farm","Visuals","Murderer","Sheriff","Player","Teleport","Players","Animations","Mobile","Config Hub","Settings","Server"}
local buttons={}
for i,name in ipairs(tabs) do
    local b=btn(nav,name)
    b.Size=UDim2.new(1,-3,0,29);b.LayoutOrder=i
    buttons[name]=b
    listen(b.MouseButton1Click,function() S.tab=name;render() end)
end
local function info(k,v) addText(k..":  "..tostring(v)) end
local function toggleEsp(label,key)
    toggle(label,"Exibir contorno e nome no personagem",key,function()
        updateRoles();updateEsp()
    end)
end
render=function()
    if not live then return end
    pageClear()
    heading.Text=string.upper(S.tab).."  /  NEXUS"
    for k,b in pairs(buttons) do
        b.BackgroundColor3=k==S.tab and T.accent or T.panel
    end
    if S.tab=="Farm" then
        info("Método",S.method)
        action("Alternar Fast / Under Map","Under tenta seguir por baixo do piso","TROCAR",function()
            if S.farm then stopFarm() end
            S.method=S.method=="Fast" and "Under Map" or "Fast"
        end)
        action("Velocidade limite: "..S.speed,"Entre 8 e 28 studs/segundo","- 2",function() S.speed=math.max(8,S.speed-2) end)
        action("Velocidade máxima","Fixar velocidade em 28","28",function() S.speed=28 end)
        toggle("AUTO FARM","Fast ou Under Map | 0,01 s por doce","farm",function(on)
            S.farm=false
            if on then startFarm() else stopFarm() end
        end)
        toggle("Noclip","Desativável durante o Farm","noclip")
        toggle("Desviar de Murderer","Necessita papel identificado pelo jogo","avoid")
        action("Distância de desvio: "..S.avoidRange,"Alterar margem do trajeto","+ 5",function()
            S.avoidRange=S.avoidRange>=41 and 16 or S.avoidRange+5
        end)
        toggle("AUTO RESET","Só reinicia com sacola cheia e papel não Murderer confirmado","autoReset",function(value)
            if value then
                updateRoles(true)
                readBagGui()
                if S.fullBag then safeReset() end
            end
        end)
        toggle("Anti-Fling","Reduz velocidades físicas extremas","antiFling")
        toggle("Aviso de AFK","Mostra aviso; não evita desconexão","afkWarning")
        action("Atualizar doces","Inicia uma nova busca no mapa","BUSCAR",function()scan(true)end)
    elseif S.tab=="Visuals" then
        toggleEsp("ESP ALL","espAll")
        toggleEsp("ESP Murderer","espMurder")
        toggleEsp("ESP Sheriff","espSheriff")
        toggleEsp("ESP Innocent","espInnocent")
        toggle("Exibir nomes","Etiqueta de jogadores","names",updateEsp)
        toggle("Exibir distância","Distância até outros jogadores","distances",updateEsp)
        action("Limpar ESP","Desligar todos os destaques","LIMPAR",function()
            S.espAll=false;S.espMurder=false;S.espSheriff=false;S.espInnocent=false;clearEsp()
        end)
        info("Fonte dos papéis",S.roleSource)
        info("Papéis recebidos",S.rolesFound)
        addText("Papéis são exibidos apenas quando informados pelo jogo; sem confirmação aparece Desconhecido.")
        info("Jogadores desenhados",S.seen)
        action("Atualizar papéis", "Consultar papéis conhecidos do jogo", "BUSCAR",function()updateRoles(true)end)
    elseif S.tab=="Murderer" then
        toggleEsp("ESP Murderer","espMurder")
        info("Seu papel confirmado",roleOf(me))
        info("Reset seguro",S.autoReset and "Ativo com proteção" or "Desligado")
        addText("O script não executa ataques automáticos. Se papel não for identificado, ele nunca o inventa.")
    elseif S.tab=="Sheriff" then
        toggleEsp("ESP Sheriff","espSheriff")
        action("Atualizar papéis","Consultar fonte de rodada quando disponível","BUSCAR",updateRoles)
    elseif S.tab=="Player" then
        action("Pular","Salto normal do personagem","PULAR",function()
            local _,h=playerParts();if h then h.Jump=true end
        end)
        action("Sentar / levantar","Alternar postura","TROCAR",function()
            local _,h=playerParts();if h then h.Sit=not h.Sit end
        end)
        action("Restaurar velocidade","Velocidade padrão do avatar","PADRÃO",function()
            local _,h=playerParts();if h then h.WalkSpeed=16 end
        end)
    elseif S.tab=="Teleport" then
        action("Doce mais próximo","Tentar mover seu personagem até ele","IR",function()
            local p=pickCoin();local _,h,root=playerParts()
            if p and root and h then root.CFrame=CFrame.new(p.Position+Vector3.new(0,2,0)) end
        end)
    elseif S.tab=="Players" then
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=me then info(p.DisplayName,roleOf(p)) end
        end
    elseif S.tab=="Animations" then
        toggle("Animação do menu","Transições e movimento no painel","motion")
        addText("Animações do painel não desbloqueiam pacotes pagos do Roblox.")
    elseif S.tab=="Mobile" then
        action("Minimizar janela","Use o botão N para reabrir","MINIMIZAR",function()win.Visible=false;open.Visible=true end)
        action("Tamanho do menu","Alterna entre 90%, 100% e 110%","AJUSTAR",function()
            S.scale=S.scale>=1.08 and .9 or S.scale+.1;fit()
        end)
    elseif S.tab=="Config Hub" then
        for n,p in ipairs(palette) do
            action("Tema: "..p[1],"Muda a cor principal do Nexus","USAR",function()
                S.theme=n;T.accent=p[2];rail.BackgroundColor3=T.accent;edition.TextColor3=T.accent
            end)
        end
    elseif S.tab=="Settings" then
        info("Último erro",S.lastError)
        action("Parar funções","Desliga Farm, noclip e ESP","PARAR",function()
            stopFarm();clearEsp();S.espAll=false;S.espMurder=false;S.espSheriff=false;S.espInnocent=false
        end)
        action("Fechar Nexus","Desliga e remove interface","FECHAR",function()
            if type(_G.NexusMobileStop)=="function" then _G.NexusMobileStop() end
        end)
    elseif S.tab=="Server" then
        info("Jogadores",#Players:GetPlayers())
        info("Place ID",game.PlaceId)
        info("Bag",S.bagInfo)
        info("Fonte da sacola",S.bagSource)
        info("Seu papel",roleOf(me))
        info("Estado do Auto Reset",S.autoReset and (S.fullBag and "Cheia" or "Monitorando") or "Desligado")
        info("Contatos tentados",S.contacts)
        info("Doces detectados",S.scanned)
        info("Desvios",S.reroutes)
        info("Reset solicitados",S.resets)
        info("Evento papéis",roleEventConn and "Conectado" or "Procurando")
        info("Status",S.status)
        info("Etapa do Farm",S.stage)
        info("Papéis recebidos",S.rolesFound)
        action("Atualizar","Atualizar painéis e fonte de papéis","ATUALIZAR",function()updateRoles();scan(true)end)
    end
end

local dragging=false;local dragAt;local winAt
listen(heading.InputBegan,function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true;dragAt=input.Position;winAt=win.Position
    end
end)
listen(UserInputService.InputChanged,function(input)
    if dragging and dragAt and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
        local delta=input.Position-dragAt
        win.Position=UDim2.new(winAt.X.Scale,winAt.X.Offset+delta.X,winAt.Y.Scale,winAt.Y.Offset+delta.Y)
    end
end)
listen(UserInputService.InputEnded,function(input)
    if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)
listen(open.MouseButton1Click,function() win.Visible=true;open.Visible=false end)
listen(minimize.MouseButton1Click,function() win.Visible=false;open.Visible=true end)
local function shutdown()
    live=false;stopFarm();clearEsp()
    for _,c in ipairs(connectionsPage) do pcall(function()c:Disconnect()end) end
    for _,c in ipairs(allConnections) do pcall(function()c:Disconnect()end) end
    if bagConn then bagConn:Disconnect() end
    if roleEventConn then roleEventConn:Disconnect() end
    for _,c in ipairs(roundConns) do c:Disconnect() end
    if screen and screen.Parent then screen:Destroy() end
    _G.NexusMobileStop=nil
end
_G.NexusMobileStop=shutdown
listen(close.MouseButton1Click,shutdown)

-- Menu aparece agora, independentemente de moedas/papéis do mapa.
local ok,err=pcall(render)
if not ok then S.lastError=tostring(err);S.status="Erro ao desenhar aba";subhead.Text=S.lastError:sub(1,70) end
print("[Nexus 11.7] Menu aberto; funções pesadas iniciam em segundo plano.")

-- Consultas são iniciadas APÓS o menu aparecer, sem travar a UI.
task.spawn(function()
    task.wait(.4)
    while live and (not bagConn or not roleEventConn) do
        local rm=ReplicatedStorage:FindFirstChild("Remotes")
        local gp=rm and rm:FindFirstChild("Gameplay")
        if gp then
            if not roleEventConn then
                local ev=gp:FindFirstChild("PlayerDataChanged")
                if ev and ev:IsA("RemoteEvent") then
                    roleEventConn=ev.OnClientEvent:Connect(function(data)
                        local ok,err=pcall(ingestRoles,data,"Evento PlayerDataChanged")
                        if not ok then S.lastError="ESP: "..tostring(err) end
                    end)
                    S.roleSource="Evento PlayerDataChanged conectado"
                end
            end
            if #roundConns==0 then
                for _,eventName in ipairs({"RoundEndFade"}) do
                    local ev=gp:FindFirstChild(eventName)
                    if ev and ev:IsA("RemoteEvent") then
                        local conn=ev.OnClientEvent:Connect(function()
                            roles={}
                            roleUpdated=-100
                            roleAt=-100
                            S.rolesFound=0
                            S.roleSource="Nova etapa: aguardando papéis"
                            S.fullBag=false
                            S.resetAttempted=false
                            S.bag=0
                            S.bagMax=0
                        end)
                        roundConns[#roundConns+1]=conn
                    end
                end
            end
            if not bagConn then
                local ev=gp:FindFirstChild("CoinCollected")
                if ev and ev:IsA("RemoteEvent") then
                    bagConn=ev.OnClientEvent:Connect(updateBag)
                    S.bagInfo="Evento de coleta conectado"
                end
            end
        end
        task.wait(2)
    end
end)
task.spawn(function()
    while live do
        local ok2,er=pcall(function()
            if S.espAll or S.espMurder or S.espSheriff or S.espInnocent or S.avoid or S.autoReset then updateRoles() end
            if S.autoReset then readBagGui() end
            if S.espAll or S.espMurder or S.espSheriff or S.espInnocent then updateEsp()
            elseif next(espObjects) then clearEsp() end
        end)
        if not ok2 then S.lastError=tostring(er) end
        task.wait(.7)
    end
end)
listen(RunService.Heartbeat,function()
    if not live or not S.antiFling then return end
    local _,h,root=playerParts()
    if h and h.Health>0 and root and (root.AssemblyLinearVelocity.Magnitude>120 or root.AssemblyAngularVelocity.Magnitude>100) then
        root.AssemblyAngularVelocity=Vector3.zero
        if not S.farm then root.AssemblyLinearVelocity=Vector3.zero end
    end
end)
listen(me.Idled,function()
    if live and S.afkWarning then subhead.Text="AFK detectado • interaja para evitar desconexão" end
end)
