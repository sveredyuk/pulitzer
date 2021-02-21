PULITZER_ENABLE_INSPECTOR=1 iex --sname main@localhost -S mix phx.server

PULITZER_ENABLE_INSPECTOR=1 PULITZER_MAIN_NODE=main@localhost iex --sname a1@localhost -S mix
PULITZER_ENABLE_INSPECTOR=1 PULITZER_MAIN_NODE=main@localhost iex --sname a2@localhost -S mix
PULITZER_ENABLE_INSPECTOR=1 PULITZER_MAIN_NODE=main@localhost iex --sname a3@localhost -S mix
PULITZER_ENABLE_INSPECTOR=1 PULITZER_MAIN_NODE=main@localhost iex --sname a4@localhost -S mix
