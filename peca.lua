peca = {name = '', type = ''} --->> Definindo a peça

function peca:new(nome) --> Criando a função para definir novas peças
	novaPeca = {}
	novaPeca = setmetatable(novaPeca, {_index = peca}) 
	novaPeca.nome = nome
	novaPeca.tipo = 'normal' --> Definindo o tipo normal
	return novaPeca
end

function peca:virarDama(peca) --> Criando a função para criar a Dama
	peca.tipo = 'dama'  --> Definindo o tipo dama 
end

return peca