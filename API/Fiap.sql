--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    id integer NOT NULL,
    nome character varying NOT NULL,
    email character varying,
    cpf character varying,
    excluido boolean DEFAULT false
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.cliente ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.cliente_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pagamento_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pagamento_status (
    id integer NOT NULL,
    nome character varying NOT NULL
);


ALTER TABLE public.pagamento_status OWNER TO postgres;

--
-- Name: pedido; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido (
    id integer NOT NULL,
    data timestamp without time zone NOT NULL,
    cliente_id integer,
    anonimo boolean NOT NULL,
    anonimo_identificador character varying,
    pedido_status_id integer NOT NULL,
    valor numeric(10,2) NOT NULL,
    cliente_observacao character varying
);


ALTER TABLE public.pedido OWNER TO postgres;

--
-- Name: pedido_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pedido ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pedido_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pedido_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido_item (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    produto_id integer NOT NULL,
    preco_unitario numeric(10,2) NOT NULL,
    quantidade smallint NOT NULL
);


ALTER TABLE public.pedido_item OWNER TO postgres;

--
-- Name: pedido_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pedido_item ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pedido_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pedido_pagamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido_pagamento (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    tipo_pagamento_id smallint NOT NULL,
    valor numeric NOT NULL,
    codigo_transacao character varying,
    pagamento_status_id smallint
);


ALTER TABLE public.pedido_pagamento OWNER TO postgres;

--
-- Name: pedido_pagamento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pedido_pagamento ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pedido_pagamento_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pedido_status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pedido_status (
    id integer NOT NULL,
    nome character varying NOT NULL
);


ALTER TABLE public.pedido_status OWNER TO postgres;

--
-- Name: pedido_status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.pedido_status ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pedido_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto (
    id integer NOT NULL,
    nome character varying NOT NULL,
    produto_categoria_id integer NOT NULL,
    preco numeric(10,2) NOT NULL,
    excluido boolean DEFAULT false,
    imagem character varying,
    descricao character varying
);


ALTER TABLE public.produto OWNER TO postgres;

--
-- Name: produto_categoria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto_categoria (
    id integer NOT NULL,
    nome character varying NOT NULL
);


ALTER TABLE public.produto_categoria OWNER TO postgres;

--
-- Name: produto_categoria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.produto_categoria ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.produto_categoria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: produto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.produto ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.produto_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: tipo_pagamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_pagamento (
    id smallint NOT NULL,
    nome character varying
);


ALTER TABLE public.tipo_pagamento OWNER TO postgres;

--
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_id_seq', 3, true);


--
-- Name: pedido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_id_seq', 4, true);


--
-- Name: pedido_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_item_id_seq', 5, true);


--
-- Name: pedido_pagamento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_pagamento_id_seq', 3, true);


--
-- Name: pedido_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pedido_status_id_seq', 4, true);


--
-- Name: produto_categoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_categoria_id_seq', 4, true);


--
-- Name: produto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produto_id_seq', 4, true);


--
-- Name: cliente cliente_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pk PRIMARY KEY (id);


--
-- Name: pagamento_status pagamento_status_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pagamento_status
    ADD CONSTRAINT pagamento_status_pk PRIMARY KEY (id);


--
-- Name: pedido_item pedido_item_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_item
    ADD CONSTRAINT pedido_item_pk PRIMARY KEY (id);


--
-- Name: pedido_pagamento pedido_pagamento_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_pagamento
    ADD CONSTRAINT pedido_pagamento_pk PRIMARY KEY (id);


--
-- Name: pedido_pagamento pedido_pagamento_un; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_pagamento
    ADD CONSTRAINT pedido_pagamento_un UNIQUE (pedido_id);


--
-- Name: pedido pedido_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pk PRIMARY KEY (id);


--
-- Name: pedido_status pedido_status_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_status
    ADD CONSTRAINT pedido_status_pk PRIMARY KEY (id);


--
-- Name: produto_categoria produto_categoria_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto_categoria
    ADD CONSTRAINT produto_categoria_pk PRIMARY KEY (id);


--
-- Name: produto produto_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pk PRIMARY KEY (id);


--
-- Name: tipo_pagamento tipo_pagamento_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_pagamento
    ADD CONSTRAINT tipo_pagamento_pk PRIMARY KEY (id);


--
-- Name: pedido cliente_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT cliente_fk FOREIGN KEY (cliente_id) REFERENCES public.cliente(id);


--
-- Name: pedido_item pedido_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_item
    ADD CONSTRAINT pedido_fk FOREIGN KEY (pedido_id) REFERENCES public.pedido(id);


--
-- Name: pedido_pagamento pedido_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_pagamento
    ADD CONSTRAINT pedido_fk FOREIGN KEY (pedido_id) REFERENCES public.pedido(id);


--
-- Name: pedido pedido_status_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_status_fk FOREIGN KEY (pedido_status_id) REFERENCES public.pedido_status(id);


--
-- Name: produto produto_categoria_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_categoria_fk FOREIGN KEY (produto_categoria_id) REFERENCES public.produto_categoria(id);


--
-- Name: pedido_item produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_item
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- Name: pedido_pagamento tipo_pagamento_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pedido_pagamento
    ADD CONSTRAINT tipo_pagamento_fk FOREIGN KEY (tipo_pagamento_id) REFERENCES public.tipo_pagamento(id);


--
-- PostgreSQL database dump complete
--

