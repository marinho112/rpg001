extends Node


#GRUPOS
const GRUPO_INIMIGO = "000000"
const GRUPO_ALIADOS = "000001"
const GRUPO_CURSOR_MOUSE = "000002"
const GRUPO_ATAQUE="000003"


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



#ATAQUES

const ATAQUE_BASICO_FISICO_CORPO_A_CORPO=1000
const ATAQUE_BASICO_FISICO_DISTANCIA=1001
const ATAQUE_BASICO_MAGICO_CORPO_A_CORPO=1002
const ATAQUE_BASICO_MAGICO_DISTANCIA=1003
const ATAQUE_AAA=1004

