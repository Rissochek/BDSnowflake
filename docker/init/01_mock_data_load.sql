truncate table public.mock_data;

\copy public.mock_data from '/data/MOCK_DATA.csv' with (format csv, header true, delimiter ',', quote '"', escape '"', null '');
\copy public.mock_data from '/data/MOCK_DATA (1).csv' with (format csv, header true, delimiter ',', quote '"', escape '"', null '');
\copy public.mock_data from '/data/MOCK_DATA (2).csv' with (format csv, header true, delimiter ',', quote '"', escape '"', null '');
\copy public.mock_data from '/data/MOCK_DATA (3).csv' with (format csv, header true, delimiter ',', quote '"', escape '"', null '');
\copy public.mock_data from '/data/MOCK_DATA (4).csv' with (format csv, header true, delimiter ',', quote '"', escape '"', null '');
\copy public.mock_data from '/data/MOCK_DATA (5).csv' with (format csv, header true, delimiter ',', quote '"', escape '"', null '');
\copy public.mock_data from '/data/MOCK_DATA (6).csv' with (format csv, header true, delimiter ',', quote '"', escape '"', null '');
\copy public.mock_data from '/data/MOCK_DATA (7).csv' with (format csv, header true, delimiter ',', quote '"', escape '"', null '');
\copy public.mock_data from '/data/MOCK_DATA (8).csv' with (format csv, header true, delimiter ',', quote '"', escape '"', null '');
\copy public.mock_data from '/data/MOCK_DATA (9).csv' with (format csv, header true, delimiter ',', quote '"', escape '"', null '');


