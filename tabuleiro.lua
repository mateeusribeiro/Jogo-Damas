classePeca = require 'peca'

tabuleiro = {     ------ Definindo o Tabuleiro formado por uma matriz
	matriz = {}
}
---------------------------------------------------------------------------------
function tabuleiro:new(tamanho)   ---- Criando o Tabuleiro
	for i = 1, tamanho do 
		self.matriz[i] = {}
		for j = 1, tamanho do 
			self.matriz[i][j] = nil 
		end
	end
end
------------------------------------------------------------------------------------
function tabuleiro:posicionarPecas() --- Posicionando as Peças
	for i = 1, #self.matriz do 
		for j = 1, #self.matriz do
			if ( i <=3) then 
				 if (i % 2 ~= 0 and j % 2 ~= 0) then
                    self.matriz[i][j] = classePeca:new('white')   --> posiciona as peças brancas
                elseif (i % 2 == 0 and j % 2 == 0) then
                    self.matriz[i][j] = classePeca:new('white')
                end
            elseif (i >= (#self.matriz - 2) and i <= (#self.matriz)) then   --> posiciona as peças pretas
                if (j % 2 == 0 and i % 2 == 0) then
                    self.matriz[i][j] = classePeca:new('black')
                elseif (i % 2 ~= 0 and j % 2 ~= 0) then
                    self.matriz[i][j] = classePeca:new('black')
                end
            else
                self.matriz[i][j] = nil
            end
        end
    end
  end
----------------------------------------------------------------
function tabuleiro:posicaoLivre(lin, col)                   ----- Posição Livre pra moviemnto 
    return self.matriz[lin][col] == nil and true or false
end
---------------------------------------------------------------
function tabuleiro:selecionaPeca(peca, lin, col)            ----> Seleciona a peça 
    if (self.matriz[lin][col] == nil) then
        return false
    end
    return self.matriz[lin][col].nome == peca.nome and true or false
end
----------------------------------------------------------------

function tabuleiro:Jogada(peca, lin, col, novalin, novacol)             ---> Efetuando a jogada
    jogadaEfetuada, capturaRealizada = false, false
    if (tabuleiro:capturarPeca(peca, lin, col, novalin, novacol)) then
        jogadaEfetuada, capturaRealizada = true, true
    elseif (tabuleiro:moverPeca(peca, lin, col, novalin, novacol)) then
        jogadaEfetuada = true
    end
    if (jogadaEfetuada and tabuleiro:promocaoValida(peca, novalin)) then
        classePeca:promover(peca)
    end
    return jogadaEfetuada, capturaRealizada
end
---------------------------------------------------------------
function tabuleiro:moverPeca(peca, lin, col, novalin, novacol)   ---> movimentando peça no jogo 
    if (tabuleiro:selecionaPeca(peca, lin, col) 
    and tabuleiro:posicaoLivre(novalin, novacol) 
    and tabuleiro:movimentoValido(peca, lin, col, novalin, novacol)) then
        self.matriz[lin][col] = nil
        self.matriz[novalin][novacol] = peca
        return true
    end
    return false
end
-------------------------------------------------------------
function tabuleiro:movimentoValido(peca, lin, col, novalin, novacol) --verifica se o movimento é válido para damas e peças normais.
    if (self.matriz[lin][col] ~= nil) then
        cont = 1
        repeat
            if (peca.nome == 'black' and peca.tipo == 'normal' and novalin > lin) then --impede que as pretas joguem voltando
                return false
            elseif (peca.nome == 'white' and peca.tipo == 'normal' and novalin < lin) then --impede que as brancas joguem voltando
                return false
            end
            if (lin + cont == novalin and col - cont == novacol and (lin + cont <= 8) and (col - cont >= 1)) then
                return true
            elseif (lin + cont == novalin and col + cont == novacol and (lin + cont <= 8) and (col + cont <= 8)) then
                return true
            elseif (lin - cont == novalin and col - cont == novacol and (lin - cont >= 1) and (col - cont >= 1)) then
                return true
            elseif (lin - cont == novalin and col + cont == novacol and (lin - cont >= 1) and (col + cont <= 8)) then
                return true
            end
            cont = peca.tipo == 'normal' and 8 or cont + 1
        until cont == 8
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------
function tabuleiro:capturaValida(peca, lin, col, novalin, novacol) ---> verifica se entre a posição da peça e a posição de destino tem uma peça inimiga
    if (lin + 2 == novalin and col - 2 == novacol and tabuleiro:pecaInimiga(peca, lin + 1, col - 1)) then
        return (lin + 1), (col - 1)
    elseif (lin + 2 == novalin and col + 2 == novacol and tabuleiro:pecaInimiga(peca, lin + 1, col + 1)) then
        return (lin + 1), (col + 1)
    elseif (lin - 2 == novalin and col - 2 == novacol and tabuleiro:pecaInimiga(peca, lin - 1, col - 1)) then
        return (lin - 1), (col - 1)
    elseif (lin - 2 == novalin and col + 2 == novacol and tabuleiro:pecaInimiga(peca, lin - 1, col + 1)) then
        return (lin - 1), (col + 1)
    end
    return nil
end
---------------------------------------------------------------------------------------------------------------------------------
function tabuleiro:capturarPeca(peca, lin, col, novalin, novacol)                                 ----> captura a peça na jogada 
    linPecaInimiga, colPecaInimiga  = tabuleiro:capturaValida(peca, lin, col, novalin, novacol)
    if((linPecaInimiga ~= nil and colPecaInimiga ~= nil)) then
        if (tabuleiro:selecionaPeca(peca, lin, col) and tabuleiro:posicaoLivre(novalin, novacol)) then
            self.matriz[novalin][novacol] = peca
            self.matriz[lin][col] = nil
            self.matriz[linPecaInimiga][colPecaInimiga] = nil
            return true
        end
    end
    return false
end
----------------------------------------------------------------------------------------------------
function tabuleiro:pecaInimiga(peca, lin, col)
    if (self.matriz[lin][col] ~= nil) then
        return self.matriz[lin][col].nome ~= peca.nome and true or false
    end
    return false
end
---------------------------------------------------------------------------------------------------
function tabuleiro:promocaoValida(peca, lin)            ---> Gerando as Damas 
    if (peca.tipo == 'normal') then
        if (peca.nome == 'white') then
            return lin == 8 and true or false
        elseif (peca.nome == 'black') then
            return lin == 1 and true or false
        end
    end
    return false
end

return tabuleiro