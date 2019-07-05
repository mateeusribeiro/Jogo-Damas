cores = {
    laranja = {238/255, 121/255, 66/255},--------->
    branco = {255/255, 255/255, 255/255},---------> Definindo as cores do jogo 
    azul = {122/255, 197/255, 205/255}------------>
}
-----------------------------------------------------------------------------------------------
local background = display.newRect(display.contentCenterX, display.contentCenterY, 800, 800)   ---> Fundo do tabuleiro
background.fill = cores.azul
------------------------------------------------------------------------------------------------
function newGame( event )                                   ----------> Função iniciar jogo 
    if ( event.phase == "began" ) then                      ----------> Definindo os eventos para inicio e termino do jogo
        event.target.alpha = 0.5
        event.target.valor.alpha = 0.5
        display.getCurrentStage():setFocus( event.target )
    elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
        event.target.alpha = 1
        event.target.valor.alpha = 1
        display.getCurrentStage():setFocus( nil )
    end
    tabuleiro:new(8)            ----------- Gerando 
    tabuleiro:posicionarPecas() ----------- Preenchendo
    mostrar(tabuleiro.matriz)   ----------- Mostrando
    pecaVez = nil
end
------------------------------------------------------------------------------------------------
newX, newY = 160, 40                                            ---> Posição do Botão novo jogo 
newButton = display.newRoundedRect(newX, newY, 600, 50, 6)      ---> Dimensionamento 
newButton.fill = cores.branco                                   ---> Definir cor 
newButton.valor = display.newText("Novo Jogo", newX, newY, native.systemFont, 24) --> Nome do botão
newButton.valor:setFillColor(191/255, 136/255, 99/255)          ---> Cor do Nome
newButton:addEventListener("touch", newGame)                    ---> Evento para quando houver o touch
-------------------------------------------------------------------------------------------------
placarX, placarY = 160, 480                                     ---> Posição para placar 
placar = display.newRoundedRect(placarX, placarY, 100, 70, 6)   ---> Placares 
placar.fill = cores.branco                                      ---> Definindo cor

pecas = {
    {nome = 'black', tipo = 'normal', created = false},         ---> definindo peças para mostrar placar 
    {nome = 'white', tipo = 'normal', created = false},
   
}
function gerarPlacar()                                          ---> Função para gerar Placar 
    x, y, z = 135, 470, 500                                     ---> Posicionamento do Placar
    for i = 1, 2 do
        if(pecas[i].created == false) then                      ---> Associando as peças com suas imagens 
            pecas[i].image = display.newImage(path(pecas[i]), x, y)
            pecas[i].image:scale(0.5, 0.5)
            pecas[i].quantidade = display.newText(getQuantidade(pecas[i]), x, z, native.systemFont, 20)
            pecas[i].quantidade:setFillColor(191/255, 136/255, 99/255)       ---> Definindo cor do placar 
            pecas[i].created = true
        else
            pecas[i].quantidade:removeSelf()
            pecas[i].quantidade = nil
            pecas[i].quantidade = display.newText(getQuantidade(pecas[i]), x, z, native.systemFont, 20)
            pecas[i].quantidade:setFillColor(191/255, 136/255, 99/255)
        end
        x = x + 50
    end
end
---------------------------------------------------------------------------------------------------------------
function getQuantidade(peca)                        --- Função para contar as peças do tabuleiro
    matriz = tabuleiro.matriz
    quantidade = 0
    for i = 1, #matriz do
        for j = 1, #matriz do
            if(matriz[i][j] ~= nil) then
                if (matriz[i][j].nome == peca.nome and matriz[i][j].tipo == peca.tipo) then
                    quantidade = quantidade + 1
                end
            end
        end
    end
    return quantidade..''                          ---> Retornando a quantidade para ser mostrada no placar 
end
---------------------------------------------------------------------------------------------------------------
pecaSelecionada, posicaoSelecionada, peca, pecaVez = nil

function moveEvent(event)                           ---> Função para movimentação das peças 
    i, j = event.target.i, event.target.j
    if (pecaVez == nil) then
        alternarJogadores()
    end
    if (tabuleiro.matriz[i][j] ~= nil and (pecaSelecionada == nil or tabuleiro.matriz[i][j].nome == peca.nome)
         and tabuleiro.matriz[i][j].nome == pecaVez) then
                pecaSelecionada = {i = i, j = j}
                    peca = tabuleiro.matriz[i][j]
    elseif (pecaSelecionada ~= nil) then
        posicaoSelecionada = {i = i, j = j}
        jogadaEfetuada, capturaRealizada = tabuleiro:Jogada(peca, pecaSelecionada.i, pecaSelecionada.j,
                             posicaoSelecionada.i, posicaoSelecionada.j)
        if (jogadaEfetuada) then
            if (not(capturaRealizada)) then
                alternarJogadores()
            end
            resetValues()
            mostrar()
        end
    end
end

function resetValues()
    peca = nil
    pecaSelecionada = nil
    posicaoSelecionada = nil
end

function alternarJogadores()
    pecaVez = pecaVez == 'white' and 'black' or 'white'
end
---------------------------------------------------------------------------------------------------------
tableGroup = display.newGroup()
tableGroup.x, tableGroup.y = 31, 40             ---> Definindo a imagem do tabuleiro

function newRect(group, x, y, width, height, i, j, color)
    local rect = nil
    if (group == nil) then
        rect = display.newRect(x, y, width, height)
    else
        rect = display.newRect(group, x, y, width, height)
    end
        rect.i, rect.j = i, j
        rect.fill = color
        rect.image = nil
    return rect
end

function tableView()                                        ----> Posicionamento das peças
    posX, posY, pecaSize = -46, 80, 39
    for i = 1, 8 do
        for j = 1, 8 do
            rect = newRect(tableGroup, posX + pecaSize * j, posY, pecaSize, pecaSize, i, j,  getCor(i, j))
            rect:addEventListener("touch", moveEvent)
        end
        posY = posY + pecaSize
    end
end

function getCor(i, j)                                        ---> alterna as cores do tabuleiro, branco e laranja .
    if (i % 2 == 0) then
        if (j % 2 == 0 and i % 2 == 0) then
            cor = cores.branco
        else
            cor = cores.laranja
        end
    else
        if (j % 2 == 0) then
            cor = cores.laranja
        else
            cor = cores.branco
        end
    end
    return cor
end
----------------------------------------------------------------------------------------------------------------
function mostrar()                          ---> Mostrar peças no tabuleiro 
    tableView()                             ---> Visualizar 
    gerarPlacar()                           ---> Gerar placar 
    matriz = tabuleiro.matriz
    posX, posY, k = 32, 40, 1
    for i = 1, #matriz do
        for j = 1, #matriz do
            if (matriz[i][j] ~= nil) then
                local image = display.newImage(tableGroup, path(matriz[i][j]), tableGroup[k].x, tableGroup[k].y)
                image:scale(0.6, 0.6)
            end
            k = k + 1
        end
    end
end

function path(peca)                                             ---> Definindo as imagens como peças do tabuleiro 
    return 'icon/peca_'..peca.nome..'_'..peca.tipo..'.png'
end
gerarPlacar()
----------------------------------------------------------------------------------------------------------------
