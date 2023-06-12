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
-- Name: claims; Type: TABLE; Schema: public; Owner: bryanbill
--

CREATE TABLE public.claims (
    id integer NOT NULL,
    description text NOT NULL,
    subscription_id integer NOT NULL,
    location character varying(255) NOT NULL,
    amount integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL
);


ALTER TABLE public.claims OWNER TO bryanbill;

--
-- Name: claims_id_seq; Type: SEQUENCE; Schema: public; Owner: bryanbill
--

CREATE SEQUENCE public.claims_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.claims_id_seq OWNER TO bryanbill;

--
-- Name: claims_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bryanbill
--

ALTER SEQUENCE public.claims_id_seq OWNED BY public.claims.id;


--
-- Name: claims_resources; Type: TABLE; Schema: public; Owner: bryanbill
--

CREATE TABLE public.claims_resources (
    id integer NOT NULL,
    claim_id integer NOT NULL,
    media_id integer NOT NULL,
    is_visible boolean NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.claims_resources OWNER TO bryanbill;

--
-- Name: claims_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: bryanbill
--

CREATE SEQUENCE public.claims_resources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.claims_resources_id_seq OWNER TO bryanbill;

--
-- Name: claims_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bryanbill
--

ALTER SEQUENCE public.claims_resources_id_seq OWNED BY public.claims_resources.id;


--
-- Name: media; Type: TABLE; Schema: public; Owner: bryanbill
--

CREATE TABLE public.media (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    file_name character varying(255) NOT NULL,
    file_size integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    url character varying(255) NOT NULL
);


ALTER TABLE public.media OWNER TO bryanbill;

--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: bryanbill
--

CREATE SEQUENCE public.media_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.media_id_seq OWNER TO bryanbill;

--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bryanbill
--

ALTER SEQUENCE public.media_id_seq OWNED BY public.media.id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: bryanbill
--

CREATE TABLE public.plans (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255) NOT NULL,
    price integer NOT NULL,
    icon character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.plans OWNER TO bryanbill;

--
-- Name: plans_id_seq; Type: SEQUENCE; Schema: public; Owner: bryanbill
--

CREATE SEQUENCE public.plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plans_id_seq OWNER TO bryanbill;

--
-- Name: plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bryanbill
--

ALTER SEQUENCE public.plans_id_seq OWNED BY public.plans.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: bryanbill
--

CREATE TABLE public.subscriptions (
    id integer NOT NULL,
    plan_id integer NOT NULL,
    user_id integer NOT NULL,
    status character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.subscriptions OWNER TO bryanbill;

--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: bryanbill
--

CREATE SEQUENCE public.subscriptions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscriptions_id_seq OWNER TO bryanbill;

--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bryanbill
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: bryanbill
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    subscription_id integer NOT NULL,
    method character varying(255) NOT NULL,
    status character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.transactions OWNER TO bryanbill;

--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: bryanbill
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transactions_id_seq OWNER TO bryanbill;

--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bryanbill
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: bryanbill
--

CREATE TABLE public.users (
    id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    avatar character varying(255),
    location character varying(255),
    password character varying(255) NOT NULL,
    role character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.users OWNER TO bryanbill;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: bryanbill
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO bryanbill;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bryanbill
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: claims id; Type: DEFAULT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.claims ALTER COLUMN id SET DEFAULT nextval('public.claims_id_seq'::regclass);


--
-- Name: claims_resources id; Type: DEFAULT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.claims_resources ALTER COLUMN id SET DEFAULT nextval('public.claims_resources_id_seq'::regclass);


--
-- Name: media id; Type: DEFAULT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.media ALTER COLUMN id SET DEFAULT nextval('public.media_id_seq'::regclass);


--
-- Name: plans id; Type: DEFAULT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.plans ALTER COLUMN id SET DEFAULT nextval('public.plans_id_seq'::regclass);


--
-- Name: subscriptions id; Type: DEFAULT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: claims; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.claims (id, description, subscription_id, location, amount, created_at, updated_at, status) FROM stdin;
3	fgf	2	23.45,45.67	45800	2023-06-11 20:38:19.424938	2023-06-11 20:38:19.424938	CANCELLED
\.


--
-- Data for Name: claims_resources; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.claims_resources (id, claim_id, media_id, is_visible, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.media (id, type, file_name, file_size, user_id, created_at, updated_at, url) FROM stdin;
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.plans (id, name, description, price, icon, created_at, updated_at) FROM stdin;
1	Akiba	SOme description of all plans	340	https://pics.me	2023-06-11 16:23:32.611994	2023-06-11 16:23:32.611994
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.subscriptions (id, plan_id, user_id, status, created_at, updated_at) FROM stdin;
2	1	5	ACTIVE	2023-06-11 16:36:10.8965	2023-06-11 16:36:10.8965
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.transactions (id, subscription_id, method, status, created_at, updated_at) FROM stdin;
2	2	MPESA	SUCCESS	2023-06-11 16:39:27.14387	2023-06-11 16:39:27.14387
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.users (id, full_name, email, avatar, location, password, role, created_at, updated_at) FROM stdin;
1	John Doe	john@doe	https://via.placeholder.com/150	Nairobi	123456	admin	2023-06-11 12:28:01.814698	2023-06-11 12:28:01.814698
2	John Doe	john@example.com		\N	1345c5782b19856518b5df660c4b8dc138d9f3160310789e291f81095693e1dc	user	2023-06-11 09:34:56.517728	2023-06-11 09:34:56.517728
5	John Doe	bill@namani.co	https://pics.me	Kenya	1345c5782b19856518b5df660c4b8dc138d9f3160310789e291f81095693e1dc	user	2023-06-11 09:38:46.051149	2023-06-11 09:38:46.051149
\.


--
-- Name: claims_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.claims_id_seq', 3, true);


--
-- Name: claims_resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.claims_resources_id_seq', 1, false);


--
-- Name: media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.media_id_seq', 1, false);


--
-- Name: plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.plans_id_seq', 1, true);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.subscriptions_id_seq', 2, true);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.transactions_id_seq', 2, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: claims claims_pkey; Type: CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.claims
    ADD CONSTRAINT claims_pkey PRIMARY KEY (id);


--
-- Name: claims_resources claims_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.claims_resources
    ADD CONSTRAINT claims_resources_pkey PRIMARY KEY (id);


--
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: plans plans_pkey; Type: CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (id);


--
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: claims_resources fk_claims_resources_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.claims_resources
    ADD CONSTRAINT fk_claims_resources_claim_id FOREIGN KEY (claim_id) REFERENCES public.claims(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: claims fk_claims_subscription_id; Type: FK CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.claims
    ADD CONSTRAINT fk_claims_subscription_id FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: media fk_media_user_id; Type: FK CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.media
    ADD CONSTRAINT fk_media_user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: subscriptions fk_subscriptions_plan_id; Type: FK CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_subscriptions_plan_id FOREIGN KEY (plan_id) REFERENCES public.plans(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: subscriptions fk_subscriptions_user_id; Type: FK CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_subscriptions_user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: transactions fk_transactions_subscription_id; Type: FK CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT fk_transactions_subscription_id FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

