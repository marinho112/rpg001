extends Node

const IDIOMA_PORTUGUES_BR = "portugues-br"

#GRUPOS
const GRUPO_INIMIGO = "000000"
const GRUPO_ALIADOS = "000001"
const GRUPO_CURSOR_MOUSE = "000002"
const GRUPO_ATAQUE="000003"
const GRUPO_SOLIDO="000004"


#TIPOS DE DANO

const TIPO_DE_DANO_CONTUSIVO=0
const TIPO_DE_DANO_CORTANTE=1
const TIPO_DE_DANO_PERFURANTE=2
const TIPO_DE_DANO_IMATERIAL=3

#RAÇA secundaria

const RACA_SECUNDARIA_HUMANO=10
const RACA_SECUNDARIA_GOBLIN=11
const RACA_SECUNDARIA_ELFO=12
const RACA_SECUNDARIA_GNOMO=13
const RACA_SECUNDARIA_ANAO=14
const RACA_SECUNDARIA_ORC=15
const RACA_SECUNDARIA_FADA=16
const RACA_SECUNDARIA_TROLL=17
const RACA_SECUNDARIA_TRITAO=18
const RACA_SECUNDARIA_ENT=19

#CLASSE
const CLASSE_COMBATENTE=50
const CLASSE_BARBARO=51
const CLASSE_RANGER=52
const CLASSE_CLERIGO=53
const CLASSE_GUERREIRO=54
const CLASSE_MONGE=55
const CLASSE_MAGO=56
const CLASSE_DRUIDA=57
const CLASSE_SAMURAI=58
const CLASSE_LADINO=59
const CLASSE_SHAMAN=60

#GRUPO RAÇA

const RACA_HUMANOIDE=100
const RACA_FERA=101
const RACA_PEIXE=102
const RACA_AVE=103
const RACA_ELEMENTAL=104
const RACA_DRAGAO=105
const RACA_MORTO_VIVO=106
const RACA_DEMONIO=107
const RACA_GOLEN=108
const RACA_PLANTA=109
const RACA_MAQUINA=110

#Tipo Elementos Menu

const TIPO_ELEMENTO_MENU_ATAQUE=200
const TIPO_ELEMENTO_MENU_ITEM=201
const TIPO_ELEMENTO_MENU_LISTA_ITENS=202
const TIPO_ELEMENTO_MENU_LISTA_MAGIAS=203
const TIPO_ELEMENTO_MENU_LISTA_HABILIDADES=204
const TIPO_ELEMENTO_MENU_LISTA = 205


#PROPRIEDADE DO ATAQUE

const PROPRIEDADE_DO_ATAQUE_NEUTRO=20 # FRACO FANTASMA 
const PROPRIEDADE_DO_ATAQUE_AGUA=21 # FRACO CONTRA RAIO e FRACO CONTRA TERRA | RESISTENCIA A GELO 
const PROPRIEDADE_DO_ATAQUE_RAIO=22 # FRACO CONTRA TERRA e FRACO CONTRA PLANTA | RESISTENCIA A AGUA
const PROPRIEDADE_DO_ATAQUE_TERRA=23 # FRACO CONTRA PLANTA e FRACO CONTRA FOGO | RESISTENCIA A RAIO
const PROPRIEDADE_DO_ATAQUE_PLANTA=24 # FRACO CONTRA FOGO e FRACO CONTRA RAIO | RESISTENCIA A TERRA
const PROPRIEDADE_DO_ATAQUE_FOGO=25 # FRACO CONTRA VENTO e FRACO CONTRA GELO  | RESISTENCIA A PLANTA
const PROPRIEDADE_DO_ATAQUE_VENTO=26 # FRACO CONTRA GELO e FRACO CONTRA AGUA  | RESISTENCIA A FOGO
const PROPRIEDADE_DO_ATAQUE_GELO=27 #FRACO CONTRA AGUA  e FRACO CONTRA FOGO | RESISTENCIA A VENTO
const PROPRIEDADE_DO_ATAQUE_MALIGNO=28 #FRACO CONTRA SAGRADO
const PROPRIEDADE_DO_ATAQUE_SAGRADO=29 #FRACO CONTRA FANTASMA
const PROPRIEDADE_DO_ATAQUE_FANTASMA=30 #FRACO CONTRA SAGRADO e FRACO CONTRA MALIGNO | RESISTENCIA A NEUTRO

# TIPO DE EQUIPAMENTOS

const EQUIPAMENTO_TIPO_ARMA=20000
const EQUIPAMENTO_TIPO_CABECA=21000 
const EQUIPAMENTO_TIPO_CORPO=22000 
const EQUIPAMENTO_TIPO_MAOS=23000
const EQUIPAMENTO_TIPO_ESCUDO=24000 
const EQUIPAMENTO_TIPO_PES=25000
const EQUIPAMENTO_TIPO_ACESSORIO=26000 

# SUBTIPO DE EQUIPAMENTOS

const EQUIPAMENTO_SUBTIPO_ARMA_ADAGA=20001
const EQUIPAMENTO_SUBTIPO_ARMA_ESPADA=20002
const EQUIPAMENTO_SUBTIPO_ARMA_MACHADO=20003
const EQUIPAMENTO_SUBTIPO_ARMA_MACA=20004
const EQUIPAMENTO_SUBTIPO_ARMA_LANCA=20005
const EQUIPAMENTO_SUBTIPO_ARMA_BASTAO=20006
const EQUIPAMENTO_SUBTIPO_ARMA_CETRO=20007
const EQUIPAMENTO_SUBTIPO_ARMA_VARINHA=20008

const EQUIPAMENTO_SUBTIPO_CABECA_CHAPEU = 21001 
const EQUIPAMENTO_SUBTIPO_CABECA_ELMO = 21002
const EQUIPAMENTO_SUBTIPO_CABECA_COROA = 21003
const EQUIPAMENTO_SUBTIPO_CABECA_TIARA = 21004
const EQUIPAMENTO_SUBTIPO_CABECA_MASCARA = 21005

const EQUIPAMENTO_SUBTIPO_CORPO_VESTES = 22001
const EQUIPAMENTO_SUBTIPO_CORPO_ARMADURA_LEVE = 22002
const EQUIPAMENTO_SUBTIPO_CORPO_ARMADURA_MEDIA = 22003
const EQUIPAMENTO_SUBTIPO_CORPO_ARMADURA_PESADA = 22004


const EQUIPAMENTO_SUBTIPO_MAOS_LUVAS = 23001
const EQUIPAMENTO_SUBTIPO_MAOS_BRACELETES = 23002
const EQUIPAMENTO_SUBTIPO_MAOS_MANOPLA = 23003

const EQUIPAMENTO_SUBTIPO_ESCUDO_ESCUDO_PEQUENO = 24001
const EQUIPAMENTO_SUBTIPO_ESCUDO_ESCUDO_GRANDE = 24002
const EQUIPAMENTO_SUBTIPO_ESCUDO_PROTECAO_DE_BRACO = 24003

const EQUIPAMENTO_SUBTIPO_PES_SAPATO = 25001
const EQUIPAMENTO_SUBTIPO_PES_BOTAS = 25002
const EQUIPAMENTO_SUBTIPO_PES_GREVAS = 25003

const EQUIPAMENTO_SUBTIPO_ACESSORIO_BRINCO = 26001
const EQUIPAMENTO_SUBTIPO_ACESSORIO_CAPUZ = 26002
const EQUIPAMENTO_SUBTIPO_ACESSORIO_CAPA = 26003
const EQUIPAMENTO_SUBTIPO_ACESSORIO_ANEL = 26004
const EQUIPAMENTO_SUBTIPO_ACESSORIO_COLAR = 26005
const EQUIPAMENTO_SUBTIPO_ACESSORIO_TOTEN = 26006

#TIPOS DE ITENS

const ITEM_TIPO_UTILIZAVEL = 27000
const ITEM_TIPO_OUTROS = 27001
const ITEM_TIPO_EQUIPAMENTO = 27002

#ATAQUES

const ATAQUE_BASICO_FISICO_CORPO_A_CORPO=10000
const ATAQUE_BASICO_FISICO_DISTANCIA=10001
const ATAQUE_BASICO_MAGICO_CORPO_A_CORPO=10002
const ATAQUE_BASICO_MAGICO_DISTANCIA=10003
const ATAQUE_AAA=1004


