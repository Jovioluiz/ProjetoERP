create database projeto;


CREATE OR REPLACE FUNCTION public.func_grava_dt_atz()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
BEGIN 
    NEW.DT_ATZ = clock_timestamp(); 
    RETURN NEW; 
END;
$function$
;

--------------------------------------------------------------

-- DROP TABLE public.log;

CREATE TABLE public.log (
	autor varchar(20) NULL,
	alteracao varchar(10) NULL,
	nome_tabela varchar(50) NULL,
	"data" timestamp NULL
);

------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.gera_log()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
insert
    into
    log(autor, alteracao, nome_tabela, data)
values (user,
TG_OP,
--retorna o tipo de alteração
 TG_RELNAME,
--retorna o nome da tabela
 now());
return new;
end;
$function$
;
-----------------------------------------------

CREATE OR REPLACE FUNCTION public.func_estoque_pedido()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    case
        when (TG_OP = 'DELETE') then 
            update produto set qtd_estoque = ( produto.qtd_estoque + old.qtd_estoque ) where produto.cd_produto = old.cd_produto;
            return old;
        when (TG_OP = 'UPDATE') then 
            update produto set qtd_estoque = ((select qtd_estoque from produto where cd_produto = old.cd_produto) - old.qtd_estoque ) where produto.cd_produto = old.cd_produto;
            return old;
        when (TG_OP = 'INSERT') then 
            update produto set qtd_estoque = ( produto.qtd_estoque - new.qtd_estoque) where produto.cd_produto = new.cd_produto;
            return new;
    end case;  
   return new;
END;
$function$
;
-------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.func_verifica_pedido_venda_item()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    case
        when (old.qtd_venda < 0 or new.qtd_venda < 0) then 
            raise exception 'Não é possível lançar quantidade negativa! ';
        else
            return new;
    end case;  
END;
$function$
;
----------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.func_estoque_nota()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    case
        when (TG_OP = 'DELETE') then 
            update produto set qtd_estoque = ( produto.qtd_estoque - old.qtd_estoque ) where produto.cd_produto = old.cd_produto;
            return new;
        when (TG_OP = 'UPDATE') then 
            update produto set qtd_estoque = ( produto.qtd_estoque - old.qtd_estoque + new.qtd_estoque ) where produto.cd_produto = new.cd_produto;
            return new;
        when (TG_OP = 'INSERT') then 
            update produto set qtd_estoque = ( produto.qtd_estoque + new.qtd_estoque) where produto.cd_produto = new.cd_produto;
            return new;
    end case;  
   return new;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.func_id_item()
 RETURNS bigint
 LANGUAGE plpgsql
AS $function$
            DECLARE
              id_item BIGINT;
            BEGIN
                /*Gera o id_item */
                SELECT NEXTVAL(PG_CLASS.OID)
                INTO id_item
                FROM PG_CLASS
                WHERE RELNAME = 'seq_id_item';
            RETURN id_item;
            END
            $function$
;

CREATE SEQUENCE public.seq_id_item
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    START 1
    CACHE 1
    NO CYCLE;
------------------------------------------------------------------------------------------------------------------------------------------

-- DROP TABLE public.login_usuario;

CREATE TABLE public.login_usuario (
	id_usuario int4 NOT NULL,
	login varchar(20) NOT NULL,
	senha varchar(20) NOT NULL,
	dt_atz timestamp NULL,
	CONSTRAINT login_usuario_pk PRIMARY KEY (id_usuario)
);

-- Table Triggers

-- DROP TRIGGER tr_gera_log ON public.login_usuario;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.login_usuario for each row execute procedure gera_log();
-- DROP TRIGGER tr_dt_atz ON public.login_usuario;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.login_usuario for each row execute procedure func_grava_dt_atz();

------------------------------------------------------------------------------------


-- DROP TABLE public.cliente;

CREATE TABLE public.cliente (
	cd_cliente int4 NOT NULL,
	nome varchar(45) NOT NULL,
	tp_pessoa varchar(10) NOT NULL,
	fl_ativo bool NOT NULL,
	telefone varchar(45) NULL,
	celular varchar(45) NULL,
	email varchar(45) NULL,
	cpf_cnpj varchar(15) NOT NULL,
	rg_ie varchar(45) NULL,
	dt_nasc_fundacao date NULL,
	fl_fornecedor bool NULL,
	dt_atz timestamp NULL,
	CONSTRAINT pk_cliente PRIMARY KEY (cd_cliente)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.cliente;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.cliente for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.cliente;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.cliente for each row execute procedure gera_log();

----------------------------------------------------------------------

-- DROP TABLE public.endereco_cliente;

CREATE TABLE public.endereco_cliente (
	cd_cliente int4 NOT NULL,
	logradouro varchar(45) NOT NULL,
	num int4 NULL,
	bairro varchar(40) NOT NULL,
	cidade varchar(20) NOT NULL,
	dt_atz timestamp NULL,
	uf varchar NULL,
	cep varchar(10) NULL,
	CONSTRAINT pk_endereco_cliente PRIMARY KEY (cd_cliente),
	CONSTRAINT endereco_fk FOREIGN KEY (cd_cliente) REFERENCES cliente(cd_cliente) ON DELETE CASCADE
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.endereco_cliente;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.endereco_cliente for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.endereco_cliente;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.endereco_cliente for each row execute procedure gera_log();
------------------------------------------------------------------------

-- Drop table

-- DROP TABLE public.estado;

CREATE TABLE public.estado (
	uf varchar(2) NOT NULL,
	nm_uf varchar(40) NULL DEFAULT NULL::character varying,
	dt_atz timestamp NULL,
	CONSTRAINT pk_estado PRIMARY KEY (uf)
);

------------------------------------------------------------------

-- DROP TABLE public.pais;

CREATE TABLE public.pais (
	cd_pais int4 NOT NULL,
	nm_pais varchar(50) NULL DEFAULT NULL::character varying,
	CONSTRAINT pk_pais PRIMARY KEY (cd_pais)
);

-------------------------------------------------------------------

-- DROP TABLE public.cidade;

CREATE TABLE public.cidade (
	cd_cidade int4 NOT NULL,
	nm_cidade varchar(40) NOT NULL,
	uf varchar(2) NOT NULL DEFAULT 'SC'::character varying,
	dt_atz timestamp NULL DEFAULT now(),
	cep varchar(8) NULL,
	cd_ibge int4 NULL,
	cd_pais int4 NULL,
	CONSTRAINT pk_cidade PRIMARY KEY (cd_cidade),
	CONSTRAINT fk_cidade_estado FOREIGN KEY (uf) REFERENCES estado(uf) ON UPDATE CASCADE,
	CONSTRAINT fk_cidade_pais FOREIGN KEY (cd_pais) REFERENCES pais(cd_pais) ON UPDATE CASCADE
);
--------------------------------------------------------------------------------------------

-- DROP TABLE public.bairro;

CREATE TABLE public.bairro (
	cidade_codigo int4 NOT NULL,
	bairro_codigo int4 NOT NULL,
	bairro_descricao varchar(72) NULL,
	dt_atz timestamp NULL DEFAULT now(),
	CONSTRAINT pk_bairro PRIMARY KEY (bairro_codigo),
	CONSTRAINT fk_bairro_cidade FOREIGN KEY (cidade_codigo) REFERENCES cidade(cd_cidade) ON DELETE CASCADE
);

---------------------------------------------------------------------------

CREATE TABLE public.endereco (
	bairro_codigo int4 NOT NULL,
	endereco_codigo int4 NOT NULL,
	endereco_cep varchar(9) NOT NULL,
	endereco_logradouro varchar(100) NULL DEFAULT NULL::character varying,
	endereco_complemento varchar(100) NULL DEFAULT NULL::character varying,
	dt_atz varchar(100) NULL,
	CONSTRAINT pk_endereco PRIMARY KEY (endereco_codigo)
);

--------------------------------------------------------------------


-- DROP TABLE public.cta_forma_pagamento;

CREATE TABLE public.cta_forma_pagamento (
	cd_forma_pag int4 NOT NULL,
	nm_forma_pag varchar(50) NOT NULL,
	fl_ativo bool NULL,
	tp_classificacao varchar(2) NULL,
	dt_atz timestamp NULL,
	CONSTRAINT pk_cta_forma_pagamento PRIMARY KEY (cd_forma_pag)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.cta_forma_pagamento;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.cta_forma_pagamento for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.cta_forma_pagamento;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.cta_forma_pagamento for each row execute procedure gera_log();

--------------------------------------------

-- DROP TABLE public.cta_cond_pagamento;

CREATE TABLE public.cta_cond_pagamento (
	cd_cond_pag int4 NOT NULL,
	nm_cond_pag varchar(50) NOT NULL,
	cd_cta_forma_pagamento int4 NOT NULL,
	nr_parcelas int4 NULL DEFAULT 0,
	vl_minimo_parcela numeric(15,4) NULL DEFAULT 0,
	fl_ativo bool NULL,
	dt_atz timestamp NULL,
	CONSTRAINT pk_cta_cond_pagamento PRIMARY KEY (cd_cond_pag),
	CONSTRAINT fk_cta_cond_pagamento_cta_forma_pagamento FOREIGN KEY (cd_cta_forma_pagamento) REFERENCES cta_forma_pagamento(cd_forma_pag)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.cta_cond_pagamento;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.cta_cond_pagamento for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.cta_cond_pagamento;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.cta_cond_pagamento for each row execute procedure gera_log();

---------------------------------------------------------------------

-- DROP TABLE public.produto;

CREATE TABLE public.produto (
	cd_produto int4 NOT NULL,
	fl_ativo bool NULL DEFAULT true,
	desc_produto varchar(50) NOT NULL,
	un_medida varchar(5) NULL,
	fator_conversao numeric(12,4) NOT NULL,
	peso_liquido numeric(10,4) NULL,
	peso_bruto numeric(10,4) NULL,
	observacao text NULL,
	dt_atz timestamp NULL,
	qtd_estoque numeric(12,4) NULL DEFAULT 0,
	tipo_cod_barras varchar(1) NULL,
	codigo_barras varchar(15) NULL,
	imagem varchar NULL,
	CONSTRAINT pk_produto PRIMARY KEY (cd_produto)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.produto;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.produto for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.produto;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.produto for each row execute procedure gera_log();

---------------------------------------------------------------------------

-- DROP TABLE public.grupo_tributacao_icms;

CREATE TABLE public.grupo_tributacao_icms (
	cd_tributacao int4 NOT NULL,
	nm_tributacao_icms varchar(50) NOT NULL,
	aliquota_icms numeric(12,4) NOT NULL,
	dt_atz timestamp NULL,
	CONSTRAINT pk_grupo_tributacao_icms PRIMARY KEY (cd_tributacao)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.grupo_tributacao_icms;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.grupo_tributacao_icms for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.grupo_tributacao_icms;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.grupo_tributacao_icms for each row execute procedure gera_log();

---------------------------------------------------------------------------------

-- DROP TABLE public.grupo_tributacao_ipi;

CREATE TABLE public.grupo_tributacao_ipi (
	cd_tributacao int4 NOT NULL,
	nm_tributacao_ipi varchar(50) NOT NULL,
	aliquota_ipi numeric(12,4) NOT NULL,
	dt_atz timestamp NULL,
	CONSTRAINT pk_grupo_tributacao_ipi PRIMARY KEY (cd_tributacao)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.grupo_tributacao_ipi;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.grupo_tributacao_ipi for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.grupo_tributacao_ipi;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.grupo_tributacao_ipi for each row execute procedure gera_log();

-------------------------------------------------------------------------------

-- DROP TABLE public.grupo_tributacao_iss;

CREATE TABLE public.grupo_tributacao_iss (
	cd_tributacao int4 NOT NULL,
	nm_tributacao_iss varchar(50) NOT NULL,
	aliquota_iss numeric(12,4) NOT NULL,
	dt_atz timestamp NULL,
	CONSTRAINT pk_grupo_tributacao_iss PRIMARY KEY (cd_tributacao)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.grupo_tributacao_iss;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.grupo_tributacao_iss for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.grupo_tributacao_iss;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.grupo_tributacao_iss for each row execute procedure gera_log();

-----------------------------------------------------------------------------

-- DROP TABLE public.grupo_tributacao_pis_cofins;

CREATE TABLE public.grupo_tributacao_pis_cofins (
	cd_tributacao int4 NOT NULL,
	nm_tributacao_pis_cofins varchar(50) NOT NULL,
	aliquota_pis_cofins numeric(12,4) NOT NULL,
	dt_atz timestamp NULL,
	CONSTRAINT pk_grupo_tributacao_pis_cofins PRIMARY KEY (cd_tributacao)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.grupo_tributacao_pis_cofins;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.grupo_tributacao_pis_cofins for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.grupo_tributacao_pis_cofins;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.grupo_tributacao_pis_cofins for each row execute procedure gera_log();

---------------------------------------------------------------------------------------

-- DROP TABLE public.produto_tributacao;

CREATE TABLE public.produto_tributacao (
	cd_produto int4 NOT NULL,
	cd_tributacao_icms int4 NOT NULL,
	cd_tributacao_ipi int4 NOT NULL,
	cd_tributacao_iss int4 NULL,
	cd_tributacao_pis_cofins int4 NOT NULL,
	dt_atz timestamp NULL,
	CONSTRAINT pk_grupo_tributacao_produto PRIMARY KEY (cd_produto),
	CONSTRAINT fk_grupo_tributacao_icms FOREIGN KEY (cd_tributacao_icms) REFERENCES grupo_tributacao_icms(cd_tributacao),
	CONSTRAINT fk_grupo_tributacao_ipi FOREIGN KEY (cd_tributacao_ipi) REFERENCES grupo_tributacao_ipi(cd_tributacao),
	CONSTRAINT fk_grupo_tributacao_iss FOREIGN KEY (cd_tributacao_iss) REFERENCES grupo_tributacao_iss(cd_tributacao),
	CONSTRAINT fk_grupo_tributacao_pis_cofins FOREIGN KEY (cd_tributacao_pis_cofins) REFERENCES grupo_tributacao_pis_cofins(cd_tributacao),
	CONSTRAINT produto_tributacao_fk FOREIGN KEY (cd_produto) REFERENCES produto(cd_produto) ON DELETE CASCADE
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.produto_tributacao;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.produto_tributacao for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.produto_tributacao;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.produto_tributacao for each row execute procedure gera_log();

-----------------------------------------------------------------------------------

-- DROP TABLE public.modelo_nota_fiscal;

CREATE TABLE public.modelo_nota_fiscal (
	cd_modelo varchar(3) NOT NULL,
	nm_modelo varchar(70) NOT NULL,
	CONSTRAINT modelo_nota_fiscal_pk PRIMARY KEY (cd_modelo)
);

-------------------------------------------------------------------------------------

-- DROP TABLE public.operacao;

CREATE TABLE public.operacao (
	cd_operacao int4 NOT NULL,
	nm_operacao varchar(70) NOT NULL,
	fl_ent_sai varchar(1) NOT NULL,
	cd_modelo_nota_fiscal varchar(3) NULL,
	CONSTRAINT operacao_pk PRIMARY KEY (cd_operacao),
	CONSTRAINT operacao_modelo_nota_fiscal_fk FOREIGN KEY (cd_modelo_nota_fiscal) REFERENCES modelo_nota_fiscal(cd_modelo)
);

-------------------------------------------------------------------------------------------------------

-- DROP TABLE public.serie_nf;

CREATE TABLE public.serie_nf (
	cd_serie int4 NOT NULL,
	nr_serie varchar(3) NOT NULL,
	descricao varchar(30) NOT NULL,
	cd_modelo_nota_fiscal varchar(2) NULL,
	CONSTRAINT pk_serie_nf PRIMARY KEY (cd_serie),
	CONSTRAINT serie_nf_fk FOREIGN KEY (cd_modelo_nota_fiscal) REFERENCES modelo_nota_fiscal(cd_modelo)
);

----------------------------------------------------------------------------------

CREATE TABLE public.tabela_preco (
	cd_tabela int4 NOT NULL,
	nm_tabela varchar(100) NOT NULL,
	fl_ativo bool NULL,
	dt_inicio date NULL,
	dt_fim date NULL,
	dt_atz timestamp NULL,
	CONSTRAINT pk_tabela_preco PRIMARY KEY (cd_tabela)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.tabela_preco;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.tabela_preco for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.tabela_preco;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.tabela_preco for each row execute procedure gera_log();

-----------------------------------------------------------------------

-- DROP TABLE public.tabela_preco_produto;

CREATE TABLE public.tabela_preco_produto (
	cd_tabela int4 NOT NULL,
	cd_produto int4 NOT NULL,
	valor numeric(12,4) NULL,
	un_medida varchar NOT NULL,
	dt_atz timestamp NULL,
	CONSTRAINT uk_tabela_preco_produto UNIQUE (cd_tabela, cd_produto),
	CONSTRAINT fk_tabela_preco_produto_produto FOREIGN KEY (cd_produto) REFERENCES produto(cd_produto) ON DELETE CASCADE,
	CONSTRAINT fk_tabela_preco_produto_tabela_preco FOREIGN KEY (cd_tabela) REFERENCES tabela_preco(cd_tabela)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.tabela_preco_produto;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.tabela_preco_produto for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.tabela_preco_produto;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.tabela_preco_produto for each row execute procedure gera_log();

-------------------------------------------------------------------------------

-- DROP TABLE public.pedido_venda;

CREATE TABLE public.pedido_venda (
	id_geral int8 NOT NULL,
	nr_pedido int4 NOT NULL,
	cd_cliente int4 NOT NULL,
	cd_forma_pag int4 NOT NULL,
	cd_cond_pag int4 NOT NULL,
	vl_desconto_pedido numeric(12,4) NOT NULL DEFAULT 0,
	vl_acrescimo numeric(12,4) NOT NULL DEFAULT 0,
	vl_total numeric(12,4) NOT NULL DEFAULT 0,
	dt_atz timestamp NULL,
	fl_orcamento bool NULL,
	dt_emissao date NULL,
	CONSTRAINT uk_pedido_venda PRIMARY KEY (id_geral),
	CONSTRAINT fk_pedido_venda_cliente FOREIGN KEY (cd_cliente) REFERENCES cliente(cd_cliente),
	CONSTRAINT fk_pedido_venda_cta_cond_pagamento FOREIGN KEY (cd_cond_pag) REFERENCES cta_cond_pagamento(cd_cond_pag),
	CONSTRAINT fk_pedido_venda_cta_forma_pagamento FOREIGN KEY (cd_forma_pag) REFERENCES cta_forma_pagamento(cd_forma_pag)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.pedido_venda;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.pedido_venda for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.pedido_venda;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.pedido_venda for each row execute procedure gera_log();

----------------------------------------------------------------------------

-- DROP TABLE public.pedido_venda_item;

CREATE TABLE public.pedido_venda_item (
	id_geral int8 NOT NULL,
	id_pedido_venda int8 NOT NULL,
	cd_produto int4 NOT NULL,
	vl_unitario numeric(12,4) NOT NULL DEFAULT 0,
	vl_total_item numeric(12,4) NOT NULL DEFAULT 0,
	qtd_venda int4 NOT NULL DEFAULT 0,
	vl_desconto numeric(12,4) NOT NULL DEFAULT 0,
	dt_atz timestamp NULL,
	cd_tabela_preco int4 NOT NULL,
	icms_vl_base numeric(12,4) NULL DEFAULT 0,
	icms_pc_aliq numeric(12,4) NULL DEFAULT 0,
	icms_valor numeric(12,4) NULL DEFAULT 0,
	ipi_vl_base numeric(12,4) NULL DEFAULT 0,
	ipi_pc_aliq numeric(12,4) NULL DEFAULT 0,
	ipi_valor numeric(12,4) NULL DEFAULT 0,
	pis_cofins_vl_base numeric(12,4) NULL DEFAULT 0,
	pis_cofins_pc_aliq numeric(12,4) NULL DEFAULT 0,
	pis_cofins_valor numeric(12,4) NULL DEFAULT 0,
	un_medida varchar(10) NULL,
	CONSTRAINT fk_pedido_venda_item_pedido_venda FOREIGN KEY (id_pedido_venda) REFERENCES pedido_venda(id_geral),
	CONSTRAINT fk_pedido_venda_item_produto FOREIGN KEY (cd_produto) REFERENCES produto(cd_produto),
	CONSTRAINT pedido_venda_item_fk FOREIGN KEY (cd_tabela_preco) REFERENCES tabela_preco(cd_tabela)
);

-- Table Triggers

-- DROP TRIGGER atualiza_estoque_pedido ON public.pedido_venda_item;

create trigger atualiza_estoque_pedido after
insert
    or
delete
    or
update
    on
    public.pedido_venda_item for each row execute procedure func_estoque_pedido();
-- DROP TRIGGER verifica_estoque_pedido_venda_item ON public.pedido_venda_item;

create trigger verifica_estoque_pedido_venda_item after
insert
    or
delete
    or
update
    on
    public.pedido_venda_item for each row execute procedure func_verifica_pedido_venda_item();
-- DROP TRIGGER tr_dt_atz ON public.pedido_venda_item;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.pedido_venda_item for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.pedido_venda_item;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.pedido_venda_item for each row execute procedure gera_log();

-------------------------------------------------------------------------------------------------

-- DROP TABLE public.nfc;

CREATE TABLE public.nfc (
	id_geral int4 NOT NULL,
	dcto_numero int4 NOT NULL,
	serie varchar NOT NULL,
	cd_fornecedor int4 NULL,
	dt_emissao timestamp NULL,
	dt_recebimento date NULL,
	dt_lancamento date NULL,
	cd_operacao int4 NOT NULL,
	cd_modelo varchar(3) NOT NULL,
	valor_servico numeric(12,4) NULL,
	vl_base_icms numeric(12,4) NULL,
	pc_aliq_icms numeric(12,4) NULL,
	valor_icms numeric(12,4) NULL,
	valor_frete numeric(12,4) NULL,
	valor_ipi numeric(12,4) NULL,
	valor_iss numeric(12,4) NULL,
	valor_desconto numeric(12,4) NULL,
	valor_acrescimo numeric(12,4) NULL,
	valor_outras_despesas numeric(12,4) NULL,
	valor_total_nota numeric(12,4) NULL,
	dt_atz timestamp NULL,
	valor_produto numeric(12,4) NULL,
	CONSTRAINT nfc_pk PRIMARY KEY (id_geral),
	CONSTRAINT nfc_fk FOREIGN KEY (cd_fornecedor) REFERENCES cliente(cd_cliente),
	CONSTRAINT nfc_modelo_nota_fiscal_fk FOREIGN KEY (cd_modelo) REFERENCES modelo_nota_fiscal(cd_modelo),
	CONSTRAINT nfc_operacao_fk FOREIGN KEY (cd_operacao) REFERENCES operacao(cd_operacao)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.nfc;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.nfc for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.nfc;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.nfc for each row execute procedure gera_log();

--------------------------------------------------------------------------

-- DROP TABLE public.nfi;

CREATE TABLE public.nfi (
	id_geral int4 NOT NULL,
	id_nfc int4 NOT NULL,
	cd_produto int4 NOT NULL,
	qtd_estoque numeric(12,4) NOT NULL,
	dt_atz timestamp NULL,
	un_medida varchar(2) NOT NULL,
	vl_unitario numeric(12,4) NOT NULL,
	vl_frete_rateado numeric(12,4) NULL DEFAULT 0,
	vl_desconto_rateado numeric(12,4) NULL DEFAULT 0,
	vl_acrescimo_rateado numeric(12,4) NULL DEFAULT 0,
	seq_item_nfi int2 NOT NULL,
	icms_vl_base numeric(15,4) NULL DEFAULT 0,
	icms_pc_aliq float8 NULL DEFAULT 0,
	icms_valor numeric(15,4) NULL DEFAULT 0,
	ipi_vl_base numeric(15,4) NULL DEFAULT 0,
	ipi_pc_aliq float8 NULL DEFAULT 0,
	ipi_valor numeric(15,4) NULL DEFAULT 0,
	pis_cofins_vl_base numeric(15,4) NULL DEFAULT 0,
	pis_cofins_pc_aliq float8 NULL DEFAULT 0,
	pis_cofins_valor numeric(15,4) NULL DEFAULT 0,
	iss_vl_base numeric(15,4) NULL DEFAULT 0,
	iss_pc_aliq float8 NULL DEFAULT 0,
	iss_valor numeric(15,4) NULL DEFAULT 0,
	CONSTRAINT pk_nfi PRIMARY KEY (id_geral),
	CONSTRAINT fk_nfi_nfc FOREIGN KEY (id_nfc) REFERENCES nfc(id_geral),
	CONSTRAINT "nota_produto_ item_fk" FOREIGN KEY (cd_produto) REFERENCES produto(cd_produto)
);

-- Table Triggers

-- DROP TRIGGER tr_dt_atz ON public.nfi;

create trigger tr_dt_atz before
insert
    or
update
    on
    public.nfi for each row execute procedure func_grava_dt_atz();
-- DROP TRIGGER tr_gera_log ON public.nfi;

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.nfi for each row execute procedure gera_log();
-- DROP TRIGGER atualiza_estoque_nfi ON public.nfi;

create trigger atualiza_estoque_nfi after
insert
    or
delete
    or
update
    on
    public.nfi for each row execute procedure func_estoque_nota();
---------------------------------------------------------------------

CREATE TABLE public.acoes_sistema (
	cd_acao int4 NOT NULL,
	nm_acao varchar(50) NULL,
	nm_formulario varchar(50) NULL,
	dt_atz timestamp NULL,
	CONSTRAINT pk_acoes_sistema PRIMARY KEY (cd_acao)
);

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.acoes_sistema for each row execute procedure gera_log();

create trigger tr_dt_atz before
insert
    or
update
    on
    public.acoes_sistema for each row execute procedure func_grava_dt_atz();

----------------------------------------------------------------------
CREATE TABLE public.usuario_acao (
	cd_usuario int4 NOT NULL,
	cd_acao int4 NOT NULL,
	fl_permite_acesso bool NULL,
	dt_atz timestamp NULL,
	CONSTRAINT usuario_acao_un UNIQUE (cd_usuario, cd_acao),
	CONSTRAINT fk_usuario_acao_acoes_sistema FOREIGN KEY (cd_acao) REFERENCES acoes_sistema(cd_acao),
	CONSTRAINT usuario_acao_fk FOREIGN KEY (cd_usuario) REFERENCES login_usuario(id_usuario)
);

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.usuario_acao for each row execute procedure gera_log();

create trigger tr_dt_atz before
insert
    or
update
    on
    public.usuario_acao for each row execute procedure func_grava_dt_atz();

-------------------------------------------------------------------------

CREATE TABLE public.configuracao (
	cd_configuracao int4 NOT NULL,
	nm_configuracao varchar(100) NOT NULL,
	descricao_configuracao varchar(100) NOT NULL,
	valor varchar(1) NULL,
	dt_atz timestamp NULL,
	CONSTRAINT pk_configuracao PRIMARY KEY (cd_configuracao)
);

create trigger tr_dt_atz before
insert
    or
update
    on
    public.configuracao for each row execute procedure func_grava_dt_atz();

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.configuracao for each row execute procedure gera_log();


-------------------------------------------------------------------------

CREATE SEQUENCE public.cliente_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
----------------------------------------------------------

CREATE SEQUENCE public.seq_id_geral
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
--------------------------------------------------------

CREATE SEQUENCE public.seq_nr_pedido
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
----------------------------------------------


CREATE OR REPLACE FUNCTION public.func_id_geral()
 RETURNS bigint
 LANGUAGE plpgsql
AS $function$
            DECLARE
              RESULTADO BIGINT;
            BEGIN
                /*Gera o id_geral */
                SELECT NEXTVAL(PG_CLASS.OID)
                INTO RESULTADO
                FROM PG_CLASS
                WHERE RELNAME = 'seq_id_geral';
            RETURN RESULTADO + 100000;
            END
            $function$
;

----------------------------------------------------------

CREATE OR REPLACE FUNCTION public.func_nr_pedido()
 RETURNS bigint
 LANGUAGE plpgsql
AS $function$
            DECLARE
              RESULTADO BIGINT;
            BEGIN
                /*Gera o nr_pedido */
                SELECT NEXTVAL(PG_CLASS.OID)
                INTO RESULTADO
                FROM PG_CLASS
                WHERE RELNAME = 'seq_nr_pedido';
            RETURN RESULTADO;
            END
            $function$;

ALTER TABLE public.produto DROP COLUMN tipo_cod_barras;
ALTER TABLE public.produto DROP COLUMN codigo_barras;

create table produto_cod_barras(
	cd_produto int4 not null,
	un_medida varchar(10),
	tipo_cod_barras int2,
	codigo_barras varchar(20),
	dt_atz timestamp,
	constraint fk_produto_cod_barras_produto foreign key (cd_produto) references produto(cd_produto) 
);

create trigger tr_dt_atz before
insert
    or
update
    on
    public.produto_cod_barras for each row execute procedure func_grava_dt_atz();

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.produto_cod_barras for each row execute procedure gera_log();

COMMENT ON COLUMN public.produto_cod_barras.tipo_cod_barras IS '0 - Interno
1 - GTIN
2 - Outro';


ALTER TABLE public.usuario_acao ADD fl_permite_edicao bool NULL;
ALTER TABLE public.produto DROP COLUMN imagem;
ALTER TABLE public.produto ADD imagem bytea NULL;
ALTER TABLE public.pedido_venda_item ADD seq_item int4 NULL;
ALTER TABLE public.pedido_venda ADD fl_cancelado varchar(1) NULL;

CREATE TABLE public.wms_endereco (
	id_geral int8 NOT NULL,
	cd_deposito int4 NULL,
	ala text NULL,
	rua text NULL,
	complemento varchar NULL,
	dt_atz timestamp NULL,
	CONSTRAINT pk_wms_endereco PRIMARY KEY (id_geral)
);

create trigger tr_dt_atz before
insert
    or
update
    on
    public.wms_endereco for each row execute procedure func_grava_dt_atz();

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.wms_endereco for each row execute procedure gera_log();

CREATE TABLE public.wms_endereco_produto (
    id_geral int8 NOT NULL,
    id_endereco int8 NOT NULL,
    nm_endereco varchar(20) NOT NULL,
    cd_produto int4 not null,
    dt_atz timestamp NULL,
    CONSTRAINT pk_wms_endereco_produto PRIMARY KEY (id_geral),
    CONSTRAINT fk_wms_endereco_produto_wms_endereco FOREIGN KEY (id_endereco) REFERENCES wms_endereco(id_geral),
    CONSTRAINT fk_wms_endereco_produto_produto FOREIGN KEY (cd_produto) REFERENCES produto(cd_produto)
);

create trigger tr_dt_atz before
insert
    or
update
    on
    public.wms_endereco_produto for each row execute procedure func_grava_dt_atz();

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.wms_endereco_produto for each row execute procedure gera_log();

create table wms_mvto_estoque(
    id_geral int8 not null,
    id_endereco_produto int8 not null,
    cd_produto int4 not null,
    qt_estoque numeric(12,4),
    un_estoque varchar(10),
    fl_entrada_saida varchar(1),
    dt_atz timestamp,
    CONSTRAINT uk_wms_mvto_estoque unique (id_geral, id_endereco_produto),
    CONSTRAINT fk_wms_mvto_estoque_wms_endereco_produto FOREIGN KEY (id_endereco_produto) REFERENCES wms_endereco_produto(id_geral),
    CONSTRAINT fk_wms_mvto_estoque_produto FOREIGN KEY (cd_produto) REFERENCES produto(cd_produto)
);

create trigger tr_dt_atz before
insert
    or
update
    on
    public.wms_mvto_estoque for each row execute procedure func_grava_dt_atz();

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.wms_mvto_estoque for each row execute procedure gera_log();

create table wms_estoque(
    id_geral int8 not null,
    id_wms_endereco_produto int8 not null,
    cd_produto int4 not null,
    qt_estoque numeric(12,4),
    un_estoque varchar(10),
    dt_atz timestamp,
    CONSTRAINT pk_wms_estoque primary key (id_geral),
    CONSTRAINT fk_wms_estoque_wms_endereco_produto FOREIGN KEY (id_wms_endereco_produto) REFERENCES wms_endereco_produto(id_geral),
    CONSTRAINT fk_wms_estoque_produto FOREIGN KEY (cd_produto) REFERENCES produto(cd_produto)
);

create trigger tr_dt_atz before
insert
    or
update
    on
    public.wms_estoque for each row execute procedure func_grava_dt_atz();

create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.wms_estoque for each row execute procedure gera_log();


ALTER TABLE public.wms_endereco_produto ADD ordem int NULL;
ALTER TABLE public.produto DROP COLUMN qtd_estoque;
alter table nfi disable trigger atualiza_estoque_nfi;

create table cxa_financeiro(
    id_geral int8 not null,
    id_pedido_venda int8,
    id_nota_entrada int8,
    cd_forma_pgto int4 not null,
    cd_cond_pgto int4 not null,
    valor numeric(12,4),
    cd_usuario int4 not null,
    fl_entrada_saida varchar(2),
    dt_pgto date,
    dt_atz timestamp,
    constraint pk_cxa_financeiro primary key(id_geral),
    CONSTRAINT fk_cxa_financeiro_pedido_venda FOREIGN KEY (id_pedido_venda) REFERENCES pedido_venda(id_geral),
    CONSTRAINT fk_cxa_financeiro_nfc FOREIGN KEY (id_nota_entrada) REFERENCES nfc(id_geral),
    CONSTRAINT fk_cxa_financeiro_forma_pgto FOREIGN KEY (cd_forma_pgto) REFERENCES cta_forma_pagamento(cd_forma_pag),
    CONSTRAINT fk_cxa_financeiro_cond_pgto FOREIGN KEY (cd_cond_pgto) REFERENCES cta_cond_pagamento(cd_cond_pag),
    CONSTRAINT fk_cxa_financeiro_usuario FOREIGN KEY (cd_usuario) REFERENCES login_usuario(id_usuario)    
);


create trigger tr_dt_atz before
insert
    or
update
    on
    public.cxa_financeiro for each row execute procedure func_grava_dt_atz();
create trigger tr_gera_log after
insert
    or
delete
    or
update
    on
    public.cxa_financeiro for each row execute procedure gera_log();

alter table pedido_venda_item disable trigger atualiza_estoque_pedido;
alter table pedido_venda_item disable trigger verifica_estoque_pedido_venda_item;

ALTER TABLE public.endereco_cliente ALTER COLUMN num TYPE varchar USING num::varchar;
ALTER TABLE public.produto_cod_barras ADD CONSTRAINT produto_cod_barras_un UNIQUE (cd_produto,un_medida,codigo_barras);


ALTER TABLE public.nfi DROP CONSTRAINT "nota_produto_ item_fk";
ALTER TABLE public.pedido_venda_item DROP CONSTRAINT fk_pedido_venda_item_produto;
ALTER TABLE public.tabela_preco_produto DROP CONSTRAINT fk_tabela_preco_produto_produto;
ALTER TABLE public.produto_tributacao DROP CONSTRAINT produto_tributacao_fk;
ALTER TABLE public.produto_cod_barras DROP CONSTRAINT fk_produto_cod_barras_produto;
ALTER TABLE public.wms_endereco_produto DROP CONSTRAINT fk_wms_endereco_produto;
ALTER TABLE public.wms_mvto_estoque DROP CONSTRAINT fk_wms_mvto_estoque_produto;
ALTER TABLE public.wms_estoque DROP CONSTRAINT fk_wms_estoque_produto;
ALTER TABLE public.produto DROP CONSTRAINT pk_produto;
ALTER TABLE public.produto ALTER COLUMN cd_produto TYPE varchar(60) USING cd_produto::varchar;

alter table produto add column id_item int4;
ALTER TABLE public.produto ALTER COLUMN id_item SET NOT NULL;
alter table produto add constraint pk_produto primary key (id_item);

ALTER TABLE public.nfi RENAME COLUMN cd_produto TO id_item;
alter table nfi add constraint fk_nfi_produto foreign key (id_item) references produto(id_item);


ALTER TABLE public.pedido_venda_item RENAME COLUMN cd_produto TO id_item;
alter table pedido_venda_item add constraint fk_pedido_venda_item_produto foreign key (id_item) references produto(id_item);

ALTER TABLE public.tabela_preco_produto RENAME COLUMN cd_produto TO id_item;
alter table tabela_preco_produto add constraint fk_tabela_preco_produto_produto foreign key (id_item) references produto(id_item);

ALTER TABLE public.produto_tributacao RENAME COLUMN cd_produto TO id_item;
alter table produto_tributacao add constraint fk_produto_tributacao_produto foreign key (id_item) references produto(id_item);

ALTER TABLE public.produto_cod_barras RENAME COLUMN cd_produto TO id_item;
alter table produto_cod_barras add constraint fk_produto_cod_barras_produto foreign key (id_item) references produto(id_item);

ALTER TABLE public.wms_endereco_produto RENAME COLUMN cd_produto TO id_item;
alter table wms_endereco_produto add constraint fk_wms_endereco_produto_produto foreign key (id_item) references produto(id_item);

ALTER TABLE public.wms_mvto_estoque RENAME COLUMN cd_produto TO id_item;
alter table wms_mvto_estoque add constraint fk_wms_mvto_estoque_produto foreign key (id_item) references produto(id_item);

ALTER TABLE public.wms_estoque RENAME COLUMN cd_produto TO id_item;
alter table wms_estoque add constraint fk_wms_estoque_produto foreign key (id_item) references produto(id_item);

ALTER TABLE public.login_usuario ALTER COLUMN senha TYPE varchar(50) USING senha::varchar;

ALTER TABLE usuario_acao drop column fl_permite_acesso;

alter table usuario_acao ALTER COLUMN fl_permite_edicao TYPE varchar(5) USING fl_permite_edicao::varchar;

CREATE TABLE public.backup_registros (
	id_geral int8 NOT NULL,
	operacao varchar(20) null,
	tabela varchar(50) not null,
	usuario text NOT NULL,
	"data" timestamp NOT NULL,
	valor text NOT NULL
);

CREATE OR REPLACE FUNCTION auditoria_registros() RETURNS TRIGGER AS $auditoria_registros$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO backup_registros SELECT func_id_geral(), TG_OP, TG_RELNAME, user, now(), old;
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO backup_registros SELECT func_id_geral(), TG_OP, TG_RELNAME, user, now(), old;
            RETURN NEW;
        END IF;
        RETURN NULL; 
    END;
$auditoria_registros$ LANGUAGE plpgsql;

CREATE TRIGGER trg_backup_registros
before UPDATE OR DELETE ON cliente
    FOR EACH ROW EXECUTE PROCEDURE auditoria_registros();


ALTER TABLE public.nfc DROP COLUMN valor_produto;
ALTER TABLE public.nfc DROP COLUMN valor_total_nota;

ALTER TABLE public.nfi ADD valor_total numeric(12,4) NULL DEFAULT 0;
ALTER TABLE public.nfc ADD valor_total numeric(12,4) NULL DEFAULT 0;

ALTER TABLE public.wms_estoque ADD CONSTRAINT wms_estoque_un UNIQUE (id_wms_endereco_produto,id_item);
ALTER TABLE public.wms_endereco_produto ADD CONSTRAINT wms_endereco_produto_un UNIQUE (id_endereco,id_item);

ALTER TABLE public.pedido_venda_item ADD CONSTRAINT pedido_venda_item_pk PRIMARY KEY (id_geral);

CREATE SEQUENCE public.usuario_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
	
CREATE TABLE contato(
	cd_contato int2 NOT NULL,
	tp_pessoa bpchar(1) NOT NULL,
	nm_contato varchar(100) NOT NULL,
	logradouro varchar(100),
	bairro varchar(100),
	cidade varchar(50),
	dt_atz timestamp,
	CONSTRAINT pk_contato PRIMARY KEY (cd_contato)
);

create trigger tr_dt_atz before
insert
    or
update
    on
    public.contato for each row execute procedure func_grava_dt_atz();
	
ALTER TABLE public.contato ADD nr_documento varchar(15) NULL;

ALTER TABLE pedido_venda_item ADD COLUMN rateado_vl_desconto numeric(12,4);
ALTER TABLE pedido_venda_item ADD COLUMN rateado_vl_acrescimo numeric(12,4);
ALTER TABLE pedido_venda_item ADD COLUMN vl_contabil numeric(12,4);

ALTER TABLE produto ADD COLUMN lanca_auto_pedido_venda bool DEFAULT FALSE;