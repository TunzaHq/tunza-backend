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

--
-- Name: activity; Type: TYPE; Schema: public; Owner: bryanbill
--

CREATE TYPE public.activity AS ENUM (
    'plans',
    'claims',
    'subscriptions',
    'users',
    'media',
    'transactions'
);


ALTER TYPE public.activity OWNER TO bryanbill;

--
-- Name: activity_type; Type: TYPE; Schema: public; Owner: bryanbill
--

CREATE TYPE public.activity_type AS ENUM (
    'login',
    'logout',
    'create',
    'update',
    'delete',
    'read'
);


ALTER TYPE public.activity_type OWNER TO bryanbill;

--
-- Name: answer_type; Type: TYPE; Schema: public; Owner: bryanbill
--

CREATE TYPE public.answer_type AS ENUM (
    'media',
    'text'
);


ALTER TYPE public.answer_type OWNER TO bryanbill;

--
-- Name: media_type; Type: TYPE; Schema: public; Owner: bryanbill
--

CREATE TYPE public.media_type AS ENUM (
    'ID_BACK',
    'ID_FRONT',
    'PASSPORT',
    'ICON',
    'OTHER'
);


ALTER TYPE public.media_type OWNER TO bryanbill;

--
-- Name: txn_method; Type: TYPE; Schema: public; Owner: bryanbill
--

CREATE TYPE public.txn_method AS ENUM (
    'MPESA',
    'FW',
    'VISA'
);


ALTER TYPE public.txn_method OWNER TO bryanbill;

--
-- Name: txn_status; Type: TYPE; Schema: public; Owner: bryanbill
--

CREATE TYPE public.txn_status AS ENUM (
    'PENDING',
    'SUCCESS',
    'FAILED'
);


ALTER TYPE public.txn_status OWNER TO bryanbill;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: bryanbill
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    user_id integer NOT NULL,
    user_agent text NOT NULL,
    ip_address inet NOT NULL,
    location text,
    activity_type public.activity_type DEFAULT 'read'::public.activity_type NOT NULL,
    activity public.activity DEFAULT 'users'::public.activity NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.activities OWNER TO bryanbill;

--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: bryanbill
--

CREATE SEQUENCE public.activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.activities_id_seq OWNER TO bryanbill;

--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bryanbill
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: bryanbill
--

CREATE TABLE public.answers (
    id integer NOT NULL,
    question_id integer NOT NULL,
    claim_id integer NOT NULL,
    answer text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.answers OWNER TO bryanbill;

--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: bryanbill
--

CREATE SEQUENCE public.answers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.answers_id_seq OWNER TO bryanbill;

--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bryanbill
--

ALTER SEQUENCE public.answers_id_seq OWNED BY public.answers.id;


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
    status text DEFAULT 'pending'::text NOT NULL,
    user_id integer
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
    file_name character varying(255) NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    url character varying(255) NOT NULL,
    type public.media_type DEFAULT 'OTHER'::public.media_type NOT NULL
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
-- Name: questions; Type: TABLE; Schema: public; Owner: bryanbill
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    plan_id integer NOT NULL,
    question text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expects public.answer_type DEFAULT 'text'::public.answer_type NOT NULL
);


ALTER TABLE public.questions OWNER TO bryanbill;

--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: bryanbill
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questions_id_seq OWNER TO bryanbill;

--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bryanbill
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


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
    method public.txn_method NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status public.txn_status DEFAULT 'PENDING'::public.txn_status
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
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: answers id; Type: DEFAULT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.answers ALTER COLUMN id SET DEFAULT nextval('public.answers_id_seq'::regclass);


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
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


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
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.activities (id, user_id, user_agent, ip_address, location, activity_type, activity, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: answers; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.answers (id, question_id, claim_id, answer, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: claims; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.claims (id, description, subscription_id, location, amount, created_at, updated_at, status, user_id) FROM stdin;
\.


--
-- Data for Name: claims_resources; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.claims_resources (id, claim_id, media_id, is_visible, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: media; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.media (id, file_name, user_id, created_at, updated_at, url, type) FROM stdin;
\.


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.plans (id, name, description, price, icon, created_at, updated_at) FROM stdin;
1	Akiba	SOme description of all plans	340	https://pics.me	2023-06-11 16:23:32.611994	2023-06-11 16:23:32.611994
4	Britam Biashara 2	Some super long description	600	https://pics.me/@ico	2023-06-14 07:25:40.870548	2023-06-14 10:40:59.061595
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.questions (id, plan_id, question, created_at, updated_at, expects) FROM stdin;
5	4	Who are the witnesses? (Comma separated)	2023-06-14 07:50:39.460621	2023-06-14 07:50:39.460621	text
6	4	Who are the witnesses? (Comma separated)	2023-06-14 09:15:48.513742	2023-06-14 09:15:48.513742	text
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.subscriptions (id, plan_id, user_id, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.transactions (id, subscription_id, method, created_at, updated_at, status) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: bryanbill
--

COPY public.users (id, full_name, email, avatar, location, password, role, created_at, updated_at) FROM stdin;
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.activities_id_seq', 10, true);


--
-- Name: answers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.answers_id_seq', 4, true);


--
-- Name: claims_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.claims_id_seq', 8, true);


--
-- Name: claims_resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.claims_resources_id_seq', 1, false);


--
-- Name: media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.media_id_seq', 7, true);


--
-- Name: plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.plans_id_seq', 4, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.questions_id_seq', 6, true);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.subscriptions_id_seq', 4, true);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.transactions_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bryanbill
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


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
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


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
-- Name: claims claims_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.claims
    ADD CONSTRAINT claims_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: answers fk_claim_id; Type: FK CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT fk_claim_id FOREIGN KEY (claim_id) REFERENCES public.claims(id) ON DELETE CASCADE;


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
-- Name: questions fk_plan_id; Type: FK CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT fk_plan_id FOREIGN KEY (plan_id) REFERENCES public.plans(id) ON DELETE CASCADE;


--
-- Name: answers fk_question_id; Type: FK CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT fk_question_id FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


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
-- Name: activities fk_user_id; Type: FK CONSTRAINT; Schema: public; Owner: bryanbill
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

