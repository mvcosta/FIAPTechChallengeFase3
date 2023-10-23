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
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (id, nome, email, cpf, excluido) FROM stdin;
1	Pedro Cunha	pedro@gmail.com	07411266051	f
2	João da Silva	joao@gmail.com	66649521060	f
3	Gabriel Santana	gaby@gmail.com	45927804004	f
\.


--
-- Data for Name: pagamento_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pagamento_status (id, nome) FROM stdin;
1	Aprovado
2	Recusado
\.


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido (id, data, cliente_id, anonimo, anonimo_identificador, pedido_status_id, valor, cliente_observacao) FROM stdin;
2	2023-08-22 18:03:39.938736	1	f		1	19.98	teste obs
3	2023-08-29 14:21:56.152444	\N	t	82a7415b-748c-498a-bfee-5ce84c6bb33b	2	17.89	obs boa
4	2023-08-29 14:39:48.638728	\N	t	fd9f0092-da4d-4bdb-bd2e-54af20985a95	4	29.97	
\.


--
-- Data for Name: pedido_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido_item (id, pedido_id, produto_id, preco_unitario, quantidade) FROM stdin;
2	2	1	9.99	2
3	3	1	9.99	1
4	3	2	7.90	1
5	4	1	9.99	3
\.


--
-- Data for Name: pedido_pagamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido_pagamento (id, pedido_id, tipo_pagamento_id, valor, codigo_transacao, pagamento_status_id) FROM stdin;
1	2	1	19.98	dd1afa52-8e87-4df7-a791-002296b741bb	1
2	3	1	17.89	6814f016-91d0-4914-848b-6f6e9b4f5fb2	1
3	4	1	29.97	73c6ebd3-69cc-4fea-9f12-4b50a24e0e00	1
\.


--
-- Data for Name: pedido_status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pedido_status (id, nome) FROM stdin;
1	Recebido
2	Em Preparação
3	Pronto
4	Finalizado
\.


--
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto (id, nome, produto_categoria_id, preco, excluido, imagem, descricao) FROM stdin;
1	Big Mac	1	9.99	f		Melhor lanche da casa
2	Coca Cola	3	7.90	f		Simplesmente Coca Cola
3	Batata Frita	2	6.49	f	\N	Batata sequinha
4	Torta de Maça	4	529.00	f	\N	Torta da vó
\.


--
-- Data for Name: produto_categoria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produto_categoria (id, nome) FROM stdin;
1	Lanche
2	Acompanhamento
3	Bebida
4	Sobremesa
\.


--
-- Data for Name: tipo_pagamento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipo_pagamento (id, nome) FROM stdin;
1	Débito
2	Crédito
\.


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

